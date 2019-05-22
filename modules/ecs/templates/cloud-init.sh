#!/bin/bash
sudo yum update -y
sudo yum install -y tree
sudo yum install -y awslogs
sudo systemctl start awslogsd
sudo chkconfig awslogs on

echo "ECS_CLUSTER=${cluster_name}" >> /etc/ecs/ecs.config
