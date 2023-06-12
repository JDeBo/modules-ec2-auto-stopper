import boto3
import os
import json

instances = list(json.loads((os.environ["EC2_INSTANCES"])).values())
stopping = json.loads((os.environ["STOPPING"]))
ec2 = boto3.client("ec2")


def lambda_handler(event, context):
    if not stopping:
        ec2.start_instances(InstanceIds=instances)
        print("started your instances: " + str(instances))
    else:
        ec2.stop_instances(InstanceIds=instances)
        print("stopped your instances: " + str(instances))
