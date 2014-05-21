#!/bin/sh

echo "INFO: ignore any 'dpkg-preconfigure: unable to re-open stdin' messages"

# apt-get -q -y update > /dev/null


# ###############################
# 		INSTALL git
# ###############################
# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'INFO: installing git'
  apt-get -q -y install git > /dev/null
  echo 'INFO: git installed.'
else
  echo 'INFO: git found'
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
# 		INSTALL ruby gems
# ###############################
$(which gem > /dev/null 2>&1)
FOUND_GEM=$?
if [ "$FOUND_GEM" -ne '0' ]; then
  echo 'INFO: installing rubygems'
  apt-get -q -y install rubygems > /dev/null
  echo 'INFO: rubygems installed.'
else
  echo 'INFO: rubygems found'
fi


# ###############################
# 		INSTALL librarian-puppet
# ###############################
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  echo "INFO: installing librarian-puppet"
  gem install librarian-puppet > /dev/null
  echo "INFO: librarian-puppet fetching modules..."
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  echo "INFO: librarian-puppet already installed"
  echo "INFO: fetching modules updates..."
  cd $PUPPET_DIR && librarian-puppet update
fi

# ###############################
# 		ssh keys
# ###############################
# Give 1 copy to vagrant & 1 to root
KeySource=/vagrant/ssh/id_rsa
KeyDestination1=/home/vagrant/.ssh/id_rsa
KeyDestination2=/root/.ssh/id_rsa
if [ -s $KeySource ]; then
	echo "INFO: copying ssh key"
	cp $KeySource $KeyDestination1
	chown vagrant:vagrant $KeyDestination1 

	mkdir -p /root/.ssh && chmod 700 /root/.ssh
	cp $KeySource $KeyDestination2	
	chown root:root $KeyDestination2

	chmod 600 $KeyDestination1 $KeyDestination2	
fi

# Print version information
echo " ----------------------------- " 
echo "INFO: `git --version`" 
echo "INFO: puppet version `puppet --version`"
echo "INFO: `librarian-puppet version`"
echo " ----------------------------- " 
