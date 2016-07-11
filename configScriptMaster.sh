#!/bin/bash
PROJECT=shruti;BUCKET_INSTALL=LoadTesting_shruti;BUCKET_RESULT=LoadTestingResults_shruti

sudo apt-get update
sudo apt-get install openjdk-7-jdk --fix-missing -yy

#install jmeter and ant
sudo apt-get install jmeter -y
sudo apt-get install ant -y
sudo apt-get install awscli -y

#remove loopback address from jmeter.properties
sudo sed -i 's/remote_hosts=127/#remote_hosts=127/' /usr/share/jmeter/bin/jmeter.properties

sudo chown -R ubuntu:ubuntu /usr/share/jmeter/
sudo mkdir /usr/share/jmeter/extras

wget https://s3.amazonaws.com/$BUCKET_INSTALL/conversion.xml -O /usr/share/jmeter/extras/conversion.xml
wget https://s3.amazonaws.com/$BUCKET_INSTALL/jmeter-results-detail-report_21.xsl -O /usr/share/jmeter/extras/jmeter-results-detail-report_21.xsl
wget https://s3.amazonaws.com/$BUCKET_INSTALL/File.jmx -O /usr/share/jmeter/extras/File.jmx
wget https://s3.amazonaws.com/$BUCKET_INSTALL/configScriptSlave -O /usr/share/jmeter/extras/configScriptSlave
wget https://s3.amazonaws.com/$BUCKET_INSTALL/slave.sh -O /usr/share/jmeter/extras/slave.sh
wget https://s3.amazonaws.com/$BUCKET_INSTALL/instanceproperties.sh -O /usr/share/jmeter/extras/instanceproperties.sh
wget https://s3.amazonaws.com/$BUCKET_INSTALL/testproperties.sh -O /usr/share/jmeter/extras/testproperties.sh
wget https://s3.amazonaws.com/$BUCKET_INSTALL/jmeter_master.sh -O /usr/share/jmeter/extras/jmeter_master.sh

source /usr/share/jmeter/extras/instanceproperties.sh
source /usr/share/jmeter/extras/testproperties.sh
mkdir /home/ubuntu/.aws
chown -R ubuntu:ubuntu /home/ubuntu/.aws
> ~/.aws/config
cat<<here >> /home/ubuntu/.aws/config
[default]
region=us-east-1
output=json
here

