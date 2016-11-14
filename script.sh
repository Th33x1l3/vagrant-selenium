#!/bin/sh
#=========================================================

#=========================================================
echo "Some clean up..."
#=========================================================
sudo dpkg --configure -a
sudo apt-get -f install
sudo apt-get --fix-missing install
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install build-essential
sudo apt-get clean
sudo apt-get autoremove

echo progress-bar >> ~/.curlrc



#=========================================================
echo "Install the packages..."
#=========================================================

sudo apt-get -y install fluxbox xorg zip unzip nano rungetty firefox autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev subversion git xvfb ruby gnupg2


#=========================================================
echo "Download Java8 for jar files (swarm jar )"
#=========================================================
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer
echo "Setting environment variables for Java 8.."
sudo apt-get install -y oracle-java8-set-default

#=========================================================
echo "*** Download and build latests ruby by source"
#=========================================================
wget -q --progress=bar:force "https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz"
tar -xzvf ruby-2.3.1.tar.gz
cd ./ruby-2.3.1
./configure
make 
sudo make install
gem install bundler
cd ../


#=========================================================
#echo "install ruby APT"
#=========================================================
#sudo apt-add-repository ppa:brightbox/ruby-ng
#sudo apt-get update
#sudo apt-get install ruby2.3 ruby2.3-dev


#=========================================================
#echo "Install ruby via RVM"
#=========================================================
#curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
#\curl -sSL https://get.rvm.io -o rvm.sh
#cat ./rvm.sh | bash -s stable


#=========================================================
echo "Download the latest chrome..."
#=========================================================
wget -q --progress=bar:force "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo rm google-chrome-stable_current_amd64.deb
sudo apt-get install -y -f

#=========================================================
echo "*** Download latest selenium server..."
#=========================================================
SELENIUM_VERSION=$(curl "https://selenium-release.storage.googleapis.com/" | perl -n -e'/.*<Key>([^>]+selenium-server-standalone[^<]+)/ && print $1')
wget -q --progress=bar:force "https://selenium-release.storage.googleapis.com/${SELENIUM_VERSION}" -O selenium-server-standalone.jar
mv ./selenium-server-standalone.jar /usr/bin/

#=========================================================
echo "*** Download latest geckodriver for ff tests"
#=========================================================

wget -q --progress=bar:force "https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz" -O "geckodriver.tar.gz"
tar -xzvf geckodriver.tar.gz 
ls -l .
mv geckodriver /usr/local/bin


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