#!/usr/bin/env python3

import argparse
import os
import sys
import math
import logging

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


logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger('sqs_status')


def get_number_of_messages(queues_str):
    """Return approximate number of messages in given queue(s).

    :param queues_str: a comma-separated list of queues to check, without deployment prefix
    :return: approximate number of messages in given queues
    """

    queues = [x.strip() for x in queues_str.split(',')]

    total_count = 0
    for queue_name in queues:
        full_queue_name = '{p}_{q}'.format(p=os.environ.get('DEPLOYMENT_PREFIX'), q=queue_name)
        try:
            queue = sqs.get_queue_by_name(QueueName=full_queue_name)
            total_count += int(queue.attributes.get('ApproximateNumberOfMessages') or 0)
        except Exception as e:
            assert e is not None  # make linters happy
            logger.warning('Unable to check queue: {q}'.format(q=full_queue_name), exc_info=True)
            continue

    return total_count


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
    return max(min_replicas, min(int(math.ceil(msg_count / scale_coef)), max_replicas))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Report recommended number of worker replicas for given queue.')
    parser.add_argument('-q', '--queue', help='queue to check')
    args = parser.parse_args()
    if not args.queue:
        print(parser.format_usage())
        sys.exit(1)

    count = get_number_of_messages(queues_str=args.queue)
    replicas = get_number_of_replicas(msg_count=count)
    print('{count} {replicas}'.format(count=count, replicas=replicas))
