#!/bin/sh

# ###############################
# 		INSTALL git
# ###############################
# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'
  apt-get -q -y update
   apt-get -q -y install git
   echo 'git installed.'
else
  echo 'git found.'
fi


# ###############################
# 		copy Puppetfile
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
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  cd $PUPPET_DIR && librarian-puppet update
fi

