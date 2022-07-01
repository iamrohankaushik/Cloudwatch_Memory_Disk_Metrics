wget https://s3.amazonaws.com/amazoncloudwatch-agent/windows/amd64/latest/amazon-cloudwatch-agent.msi -OutFile C:\Users\Public\Desktop\amazon-cloudwatch-agent.msi -UseBasicParsing
Test-Path -Path C:\Users\Public\Desktop\amazon-cloudwatch-agent.ms
msiexec /i C:\Users\Public\Desktop\amazon-cloudwatch-agent.msi
Start-Sleep -s 15
cd C:'\\Program Files\\Amazon\\AmazonCloudWatchAgent'
echo '{
     "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "metrics": {
        "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "aggregation_dimensions" : [ ["InstanceId"] ],
    "metrics_collected": {
       "LogicalDisk": {
        "measurement": [
        {"unit": "Percent"},
        "% Free Space "
        ],
        "resources": [
          "*"
        ]
      }
      }
    }
  }
}' > amazon-cloudwatch-agent.json
& $Env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -m ec2 -a stop
& $Env:ProgramFiles\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1 -m ec2 -a start
