#!/bin/sh

# remove any existing puppet binaries
rm -f /opt/vagrant_ruby/bin/puppet*

# pull down latest puppet 
if [ ! -e /var/puppet-updated ]; then
  wget -O /tmp/puppetlabs-release-precise.deb http://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i /tmp/puppetlabs-release-precise.deb
  apt-get --assume-yes install puppet
  touch /var/puppet-updated
fi
