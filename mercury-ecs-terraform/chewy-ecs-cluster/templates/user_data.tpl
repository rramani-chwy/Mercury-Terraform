#!/bin/bash
export ECS_CLUSTER=${cluster_name}
echo ECS_CLUSTER=${cluster_name} > /etc/ecs/ecs.config

# ulimit update
echo "* soft nofile 1000000" > /etc/security/limits.d/*_limits.conf && echo "* hard nofile 1000000" >> /etc/security/limits.d/*_limits.conf

## setup logging
sudo yum install -y awslogs
sudo mv /etc/awslogs/awslogs.conf /etc/awslogs/awslogs.conf.bk

sudo touch /etc/awslogs/awslogs.conf
curl https://s3-us-west-2.amazonaws.com/awslogs-config/awslogs.conf > /etc/awslogs/awslogs.conf

sudo sed -i -e "s/{cluster_name}/${cluster_name}/g" /etc/awslogs/awslogs.conf
sudo sed -i -e "s/region.*/region = ${region}/" /etc/awslogs/awscli.conf

sudo service awslogs start
sudo chkconfig awslogs on
