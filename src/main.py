import boto3
import os
import json

region = 'us-east-2'
instances = list(json.loads((os.environ['EC2_INSTANCES'])).values())
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))