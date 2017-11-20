#!/usr/bin/env python3

import argparse
import os
import sys
import math

import boto3

conn_args = {
    'aws_access_key_id': os.getenv('AWS_SQS_ACCESS_KEY_ID'),
    'aws_secret_access_key': os.getenv('AWS_SQS_SECRET_ACCESS_KEY'),
    'region_name': 'us-east-1'
}
sqs = boto3.resource('sqs', **conn_args)


default_max_replicas = 6
default_min_replicas = 1
default_scale_coef = 100


def get_number_of_messages(queue_name):
    """Return approximate number of messages in given queue.

    :param queue_name: name of the queue to check
    :return: approximate number of messages in the given queue
    """
    queue = sqs.get_queue_by_name(QueueName=queue_name)
    return queue.attributes.get('ApproximateNumberOfMessages')


def get_number_of_replicas(msg_count):
    """Return recommended number of replicas for given message count.

    Min and max limits are honored.

    :param msg_count: number of messages in the given queue
    :return: recommended number of replicas

    >>> get_number_of_replicas(1000)
    6
    >>> get_number_of_replicas(999)
    6
    >>> get_number_of_replicas(0)
    1
    >>> get_number_of_replicas(101)
    2
    """
    max_replicas = int(os.environ.get('MAX_REPLICAS', default_max_replicas))
    min_replicas = int(os.environ.get('DEFAULT_REPLICAS', default_min_replicas))
    scale_coef = int(os.environ.get('SCALE_COEF', default_scale_coef))
    return max(min_replicas, min(int(math.ceil(msg_count/scale_coef)), max_replicas))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Report recommended number of worker replicas for given queue.')
    parser.add_argument('-q', '--queue', help='queue to check')
    args = parser.parse_args()
    if not args.queue:
        print(parser.format_usage())
        sys.exit(1)

    count = get_number_of_messages(queue_name=args.queue)
    replicas = get_number_of_replicas(msg_count=count)
    print('{count} {replicas}'.format(count=count, replicas=replicas))
