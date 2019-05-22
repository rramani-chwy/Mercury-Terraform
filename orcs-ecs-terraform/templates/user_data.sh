#!/bin/bash
sudo yum update -y
sudo yum install -y tree
sudo yum install -y awslogs
sudo yum install -y systemd
sudo systemctl start awslogsd
sudo chkconfig awslogs on
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent

echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
sudo systemctl restart ecs-agent
