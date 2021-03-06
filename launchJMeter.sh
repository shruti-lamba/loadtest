#/bin/bash
source instanceproperties.sh
source testproperties.sh

echo "------------------Creating JMETER Master-----------------------------"
>./JMeterKey.pem
## create key pair for JMeter Master
aws ec2 create-key-pair --key-name JMeterKey --query 'KeyMaterial' --output text > ./JMeterKey.pem

sleep 10
InstanceID=$(aws ec2 run-instances --image-id $AMI --iam-instance-profile Name=LoadTesting-Instance-Profile --key-name JMeterKey --security-group-ids $SecurityGroup --instance-type $InstanceType --user-data file://configScriptMaster.sh --subnet $Subnet --associate-public-ip-address --output json | grep "InstanceId" | awk '{print $2}' | sed 's/\"//g' | sed 's/\,//g')

sleep 10

echo "JMETER Master created, Instance id= "$InstanceID
MasterIP=$(aws ec2 describe-instances --instance-id $InstanceID --output json | grep "PublicIpAddress" | awk '{print $2}' | sed 's/\"//g' | sed 's/\,//g')
aws ec2 create-tags --resource $InstanceID --tags Key=Name,Value=Master_$PROJECT
echo "Master IP= "$MasterIP
echo "Wait while Master Instance is configured"
sleep 300
echo "Done!"


########### ssh into master
echo "About to run tests!"
#SSH_COMMAND="bash -x /usr/share/jmeter/extras/jmeter_master.sh"
chmod 400 JMeterKey.pem
ssh -i JMeterKey.pem -o "StrictHostKeyChecking no" ubuntu@$MasterIP -t "sudo bash -x /usr/share/jmeter/extras/jmeter_master.sh"

#aws ec2 stop-instances --instance-ids $InstanceID
######display that tests are done
