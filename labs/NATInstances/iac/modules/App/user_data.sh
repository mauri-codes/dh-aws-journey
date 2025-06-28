#!/bin/bash
yum update -y
yum install -y aws-cli

echo "------"
cd /home/ec2-user
# aws s3 cp s3://${bucket_name}/labs/NATInstances/package/AppInstance ./app
# chmod +x ./app

nohup ./app > app.log 2>&1 &
