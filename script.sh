#!/bin/sh
#=========================================================

#=========================================================
echo "Some clean up..."
#=========================================================
apt-get update && apt-get upgrade -y && apt-get autoremove && apt-get autoclean



#=========================================================
echo "Install the packages..."
#=========================================================

sudo apt-get -y install fluxbox xorg unzip nano default-jre rungetty firefox autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev subversion git xvfb


#=========================================================
echo "*** Download and build latests ruby"
#=========================================================
wget -q --progress=bar:force "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
tar -xzvf ruby-2.3.1.tar.gz
cd ./ruby-2.3.1
./configure
make 
sudo make install
gem install bundler

#=========================================================
echo "Download the latest chrome..."
#=========================================================
wget -q --progress=bar:force "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo rm google-chrome-stable_current_amd64.deb
sudo apt-get install -y -f

#=========================================================
echo "*** Download latest selenium server..."
#=========================================================
SELENIUM_VERSION=$(curl "https://selenium-release.storage.googleapis.com/" | perl -n -e'/.*<Key>([^>]+selenium-server-standalone[^<]+)/ && print $1')
wget -q --progress=bar:force "https://selenium-release.storage.googleapis.com/${SELENIUM_VERSION}" -O selenium-server-standalone.jar
mv ./selenium-server-standalone.jar /usr/bin/

#=========================================================
echo "*** Download latest chrome driver..."
#=========================================================
rm -r /tmp/chromedriver/
mkdir /tmp/chromedriver/ &&
wget -q --progress=bar:force -O /tmp/chromedriver/LATEST_RELEASE http://chromedriver.storage.googleapis.com/LATEST_RELEASE &&
latest=$(cat /tmp/chromedriver/LATEST_RELEASE) &&
wget -q --progress=bar:force -O /tmp/chromedriver/chromedriver.zip 'http://chromedriver.storage.googleapis.com/'$latest'/chromedriver_linux64.zip' &&
sudo unzip /tmp/chromedriver/chromedriver.zip chromedriver -d /usr/local/bin/ &&
echo 'success?'



#=========================================================
echo "Add Jenkins user"
#=========================================================
sudo adduser --disabled-password --gecos '' jenkins
sudo passwd -d jenkins
sudo adduser jenkins sudo
export APP_HOME="/home/jenkins/app"

su jenkins
echo "gem: --no-rdoc --no-ri" >> /home/jenkins/.gemrc
mkdir /home/jenkins/.subversion


echo "[global]" >> /home/jenkins/.subversion/servers
echo "store-plaintext-passwords=off" >> /home/jenkins/.subversion/servers
sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
mkdir /home/jenkins/app
sudo chown -R jenkins:jenkins /home/jenkins/app
#=========================================================
echo "ALL DONE!!!"
#=========================================================