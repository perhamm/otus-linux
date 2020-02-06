#! /usr/bin/env python



import boto

import boto.s3.connection

import sys

access_key = sys.argv[1]

secret_key = sys.argv[2]



conn = boto.connect_s3(
        aws_access_key_id = access_key,
        aws_secret_access_key = secret_key,
        host = '192.168.63.17',
        is_secure=False,               # uncomment if you are not using ssl
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
        )




bucket = conn.create_bucket('my-commit-objects')
bucket = conn.create_bucket('my-fs-objects')
bucket = conn.create_bucket('my-block-objects')



for bucket in conn.get_all_buckets():
        print "{name}\t{created}".format(
                name = bucket.name,
                created = bucket.creation_date,
        )

