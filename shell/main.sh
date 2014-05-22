#!/bin/sh

echo "INFO: ignore any 'dpkg-preconfigure: unable to re-open stdin' messages"

echo "INFO: fetching apt-get updates..."
apt-get -q -y update > /dev/null


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
# 		INSTALL & RUN librarian-puppet
# ###############################
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  echo "INFO: installing librarian-puppet"
  gem install rdoc librarian-puppet > /dev/null
else
  echo "INFO: librarian-puppet already installed"
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
