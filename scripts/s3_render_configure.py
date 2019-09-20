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

from jinja2 import Template
import boto3


def get_names_from_loopback_999_description():
    try:
        description = cli("show interface Loopback999 description")
    except Exception as e:
        print('error retrieving Loopback999 description')
        print(e)
        exit()
    try:
        results_dict = dict()
        index = description.find('CRON_ARGUMENTS')
        description_text = description[index:]
        argument_list = description_text.split()
        results_dict['bucket_name'] = argument_list[1]
        results_dict['template_file'] = argument_list[2]
        results_dict['variables_file'] = argument_list[3]
    except Exception as e:
        print('error parsing Loopback999 description')
        print(e)
        exit()

    return results_dict


def generate_configuration(s3_dict):
    try:
        s3 = boto3.client('s3')
        data = s3.get_object(Bucket=s3_dict['bucket_name'], Key=s3_dict['template_file'])
        contents = data['Body'].read()
        data = contents.decode()
        template = data.split('\n')
    except Exception as e:
        print('error retrieving template')
        print(e)
        exit()
    try:
        data = s3.get_object(Bucket=s3_dict['bucket_name'], Key=s3_dict['variables_file'])
        contents = data['Body'].read()
        data = contents.decode()
        variables_dict = json.loads(data)
    except Exception as e:
        print('error retrieving variables')
        print(e)
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
    s3_info = get_names_from_loopback_999_description()
    config = generate_configuration(s3_info)
    configure_router(config)
