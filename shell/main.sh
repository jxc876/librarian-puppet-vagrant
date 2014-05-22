#!/bin/sh

# ###############################
# 		ssh keys
# ###############################
# Copy any `id_rsa` file in ssh folder
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
else
	echo "INFO: no ssh keys found"
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
# 		RUN librarian-puppet
# ###############################
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  echo "INFO: librarian-puppet install..."
  cd $PUPPET_DIR && librarian-puppet install --clean
else
  echo "INFO: librarian-puppet update..."
  cd $PUPPET_DIR && librarian-puppet update
fi

# ###############################
# Done! Print version information
# ###############################
echo " ----------------------------- " 
echo "INFO: `git --version`" 
echo "INFO: `ruby --version | cut -d' ' -f1,2`"
echo "INFO: puppet version `puppet --version`"
echo "INFO: `librarian-puppet version`"
echo " ----------------------------- " 
