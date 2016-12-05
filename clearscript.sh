#!/bin/bash

#==================================================================
echo 'Remove build files'
#==================================================================
rm -fr /home/vagrant/ruby*
rm -fr /home/vagrant/geckodriver*

#==================================================================
echo  'Remove APT cache'
#==================================================================
apt-get clean -y
apt-get autoclean -y

#==================================================================
echo 'Zero free space to aid VM compression'
#==================================================================
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

#==================================================================
# Remove bash history
#==================================================================
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

#==================================================================
echo 'Cleanup log files'
#==================================================================
find /var/log -type f | while read f; do echo -ne '' > $f; done;

#==================================================================
echo 'Whiteout root'
#==================================================================
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`; 
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;
 
#==================================================================
echo 'Whiteout /boot'
#==================================================================
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;
 
swappart=$(cat /proc/swaps | grep -v Filename | tail -n1 | awk -F ' ' '{print $1}')
if [ "$swappart" != "" ]; then
  swapoff $swappart;
  dd if=/dev/zero of=$swappart;
  mkswap $swappart;
  swapon $swappart;
fi

#==================================================================
echo 'ALL CLEANUP DONE'
#==================================================================