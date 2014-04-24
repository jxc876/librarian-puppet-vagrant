#!/bin/sh

echo "INFO: ignore any 'dpkg-preconfigure: unable to re-open stdin' messages"

# ###############################
# 		INSTALL git
# ###############################
# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'INFO: installing git'
  apt-get -q -y update > /dev/null
  apt-get -q -y install git > /dev/null
  echo 'INFO: git installed.'
else
  echo 'INFO: git found'
fi


# ###############################
# 		UPDATE Puppet
# ###############################
echo "INFO: removing default puppet binaries"
rm -f /opt/vagrant_ruby/bin/puppet*

if [ ! -e /var/puppet-updated ]; then
  echo "INFO: updating puppet to latest version"
  wget -q -O /tmp/puppetlabs-release-precise.deb http://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i /tmp/puppetlabs-release-precise.deb > /dev/null
  apt-get update > /dev/null
  apt-get -q -y install puppet > /dev/null
  touch /var/puppet-updated
fi


# ###############################
# 		COPY Puppetfile
# ###############################
# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

if [ ! -d "$PUPPET_DIR" ]; then
  mkdir -p $PUPPET_DIR
fi
cp /vagrant/puppet/Puppetfile $PUPPET_DIR


# ###############################
# 		INSTALL librarian-puppet
# ###############################
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  echo "INFO: installing librarian-puppet"
  gem install librarian-puppet > /dev/null
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  echo "INFO: librarian-puppet already installed"
  cd $PUPPET_DIR && librarian-puppet update
fi


# Print version information
echo " ----------------------------- " 
echo "INFO: `git --version`" 
echo "INFO: puppet version `puppet --version`"
echo "INFO: `librarian-puppet version`"
echo " ----------------------------- " 
