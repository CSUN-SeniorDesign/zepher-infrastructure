import boto3
from pprint import pprint
client = boto3.client('ecs')


def main(event, context):
    response = client.update_service(
        cluster='zephyrecscluster',
        service='test-http',
        desiredCount=2,
        taskDefinition='task1:8',
        deploymentConfiguration={
            'maximumPercent': 200,
            'minimumHealthyPercent': 100
        },
        platformVersion='null',
        forceNewDeployment=True,
        healthCheckGracePeriodSeconds=60
    )