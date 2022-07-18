#!/bin/bash
cd /tmp
#################  Amazon linux package ############
#wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
########## install Amazon linux package      ##########
#sudo rpm -U amazon-cloudwatch-agent.rpm
#amazon-linux-extras install collectd  -y
###############   ubuntu linux package
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
##########  install ubuntu linux package    ###########
dpkg -i -E ./amazon-cloudwatch-agent.deb
apt-get install collectd -y
    mkdir /usr/share/collectd
    touch /usr/share/collectd/types.db
echo '{
        "agent": {
                "metrics_collection_interval": 1,
                "run_as_user": "cwagent"
        },
        "metrics": {
                "aggregation_dimensions": [
                        [
                                "InstanceId"
                        ]
                ],
                "append_dimensions": {
                        "InstanceId": "${aws:InstanceId}"                        
                },
                "metrics_collected": {
                        "collectd": {
                                "metrics_aggregation_interval": 60
                        },
                        
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 1
                        }
                }
        }
}' > /opt/aws/amazon-cloudwatch-agent/bin/config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
 /bin/systemctl restart amazon-cloudwatch-agent.service
 /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
  /bin/systemctl start amazon-cloudwatch-agent.service
