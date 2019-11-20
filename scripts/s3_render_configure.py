#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""

Copyright (c) 2019 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.

"""
__author__ = "Steven Mosher <stmosher@cisco.com>"
__copyright__ = "Copyright (c) 2019 Cisco and/or its affiliates."
__license__ = "Cisco Sample Code License, Version 1.1"

from cli import configurep
from cli import cli
import json
import sys
import time

from jinja2 import Template
import boto3


def generate_configuration(s3_dict):
    counter = 0
    while counter < 5:
        try:
            s3 = boto3.client('s3')
            data = s3.get_object(Bucket=s3_dict['bucket_name'], Key=s3_dict['template_file'])
            contents = data['Body'].read()
            data = contents.decode()
            template = data.split('\n')
            break
        except Exception as e:
            print('error retrieving template')
            print(e)
            counter += 1
            time.sleep(10)

    if counter == 5:
        print('too many failures retrieving template, Exiting...')
        exit()

    counter = 0
    while counter < 5:
        try:
            data = s3.get_object(Bucket=s3_dict['bucket_name'], Key=s3_dict['variables_file'])
            contents = data['Body'].read()
            data = contents.decode()
            variables_dict = json.loads(data)
            break
        except Exception as e:
            print('error retrieving variables')
            print(e)
            counter += 1
            time.sleep(10)

    if counter == 5:
        print('too many failures retrieving variables, Exiting...')
        exit()

    # Render Configuration
    try:
        configuration = list()
        for line in template:
            t = Template(line)
            new_line = t.render(variables_dict)
            configuration.append(new_line)
    except Exception as e:
        print('error rendering configuration')
        print(e)
        exit()

    return configuration


def configure_router(conf_list):
    try:
        configurep(conf_list)
    except Exception as e:
        print('error configuring the router')
        print(e)
        exit()


if __name__ == '__main__':
    if len(sys.argv) != 4:
        print('Must have 3 arguments to run script: $bucket_name, $template_file, $variables_file')
        exit()
    s3_info = dict(bucket_name=sys.argv[1],
                   template_file=sys.argv[2],
                   variables_file=sys.argv[3])
    config = generate_configuration(s3_info)
    configure_router(config)
