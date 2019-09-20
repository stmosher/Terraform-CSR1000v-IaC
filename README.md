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
    - ```````` sudo pip install boto3 ```````` 
    - ```````` sudo pip install jinja2 ```````` 
5. Create s3_render_configure.py and copy contents from this repository to /home/guestshell
6. Create run_pscript.sh can copy contents from this repository to /home/guestshell
7. Make both files executable
    - ```````` chmod 700 $INSERTFILENAME ```````` 
8. Add job to crontab: crontab -e: e.g.,
    - ````````*/2 * * * * . $HOME/.bash_profile; /home/guestshell/run_pscript.sh >> ~/log 2>&1````````
9. Create AMI for instance
10. Give Future deployed router IAM role with permission to access your S3 configuration files
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
