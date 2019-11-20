# Immutable CSR1000v for AWS
## Description
Summary: Enable Deployment of a self-configured immutable CSR1000v router in AWS. 

The scripts in this repository allow baking your own CSR1000v AMI with the ability to pull from S3 for a jinja2 
configuration template file and json variables file. The router will then configure itself.

## Installation
1. Launch CSR1000v EC2 instance
2. Enable Guestshell
    - ````````guestshell enable ````````
3. Access Guestshell Bash environment
    - `````` guestshell run bash ``````
4. Install dependencies
    - ```````` sudo python -m pip install --upgrade pip ```````` 
    - ```````` sudo pip install boto3 ```````` 
    - ```````` sudo pip install jinja2 ````````  
5. In guestshell, create /bootflash/s3_render_configure.py with contents from this repository's ./scripts/s3_render_configure.py
6. Create AMI from instance
7. Give Future deployed router IAM role with permission to access your S3 configuration files
````````
For permission example
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::terraformdemoswm"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": ["arn:aws:s3:::terraformdemoswm/*"]
    }
  ]
}
 ```````` 

## Usage
1. Fill in variables in ./networking/demo1.auto.tfvars.json and ./vpc/demo1.auto.tfvars.json
2. Launch using terraform

The router will boot up and pull its configuration from S3.

To debug EEM use: 
    - ```````` debug event manager action cli ````````  
