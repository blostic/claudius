#!/bin/bash

#sudo ssh -v -i Piotr-key-pair-irleand.pem ubuntu@ec2-54-72-49-235.eu-west-1.compute.amazonaws.com 'bash -s' < local_script.sh
#ssh root@MachineB 'bash -s' < local_script.sh
echo "Entered VM"

#building gcc 
yes | sudo apt-get update
yes | sudo apt-get install build-essential

#installing redis 2.8
wget http://download.redis.io/releases/redis-2.8.3.tar.gz
tar -xvzf redis-2.8.3.tar.gz
cd redis-2.8.3  
yes | sudo make  
yes | sudo make install
cd ..

echo "Redis Installed "
redis-server --version

#installing nodejs
yes | sudo apt-get install python-software-properties python g++ make
yes | sudo add-apt-repository ppa:chris-lea/node.js	
yes | sudo apt-get update
yes | sudo apt-get install nodejs

echo "Nodejs Installed"
nodejs --version

#installing ruby
yes | sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz
tar -xvzf ruby-2.0.0-p353.tar.gz
cd ruby-2.0.0-p353/
./configure --prefix=/usr/local
yes | sudo make
yes | sudo make install
cd 
echo "Ruby Installed"
ruby --version

#installing Rabbit
yes | sudo apt-get install rabbitmq-server

echo "Rabbit Installed"

#installing git

yes | sudo apt-get install git-core
git --version

#installing hyperflow
cd
git clone https://github.com/dice-cyfronet/hyperflow.git --depth 1 -b develop
cd hyperflow
yes | npm install
cd ..

echo "hyperflow Installed"

#installing executor
curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem
sudo gem install --no-ri --no-rdoc hyperflow-amqp-executor.gem 
echo "executor Installed"

#installing mongage
curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz
tar zxvf Montage_v3.3_patched_4.tar.gz
cd Montage_v3.3_patched_4
make
cd ..
echo "montage Installed"
