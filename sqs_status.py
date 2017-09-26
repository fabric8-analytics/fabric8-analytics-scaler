#!/usr/bin/python3

import argparse
import os
import sys

import boto3

conn_args = {
    'aws_access_key_id': os.getenv('AWS_SQS_ACCESS_KEY_ID'),
    'aws_secret_access_key': os.getenv('AWS_SQS_SECRET_ACCESS_KEY'),
    'region_name': 'us-east-1'
}
sqs = boto3.resource('sqs', **conn_args)


def get_number_of_messages(queue_name):
    """Return approximate number of messages in given queue.

    :param queue_name: name of the queue to check
    :return approximate: number of messages in the given queue
    """
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    return queue.attributes.get('ApproximateNumberOfMessages')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Report approximate number of messages in given queue.')
    parser.add_argument('-q', '--queue', help='queue to check')
    args = parser.parse_args()
    if not args.queue:
        print(parser.format_usage())
        sys.exit(1)

    print(get_number_of_messages(queue_name=args.queue))
