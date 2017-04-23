# REA Pre-Interview Task Solution
For more information about the task, see: https://github.com/rea-cruitment/simple-sinatra-app

This solution deploys a new Amazon AWS EC2 instance using CloudFormation and configures the server using Salt.

## Requirements
 * An AWS Account
 * awscli tools, configured with an Access Key for your AWS Account

## How to deploy

1. Download the cloudformation-template.json and cloudformation-params.json from this repository
2. Customise the parameters defined in cloudformation-params.json as required
 * InstanceType (default: t2.micro)
 * KeyName (default: 'desktop')
 * SSHLocation (default: 0.0.0.0/0)
3. Run the following command, substituting the path to your cloudformation-template.json and cloudformation-params.json, and optionally the stack-name to something different:

 `aws cloudformation create-stack --stack-name davidb-rea-deploy --template-body file:///home/davidb/rea-deploy/cloudformation-template.json --parameters file:///home/davidb/rea-deploy/cloudformation-params.json`

 This will begin the deployment. It will take a few minutes for the EC2 instance, and the simple-sinatra-app, to be available

4. To find out the URL of the simple-sinatra-app run the following command, substituting the stack-name from the previous step.

 You may need to wait a minute for the EC2 instance to be available first:

 `aws cloudformation --region ap-southeast-2 describe-stacks --stack-name davidb-rea-deploy --query 'Stacks[0].Outputs[0].OutputValue'`

5. Visit the URL in a web browser.

 As previously mentioned, the deploy does take a few minutes so the simple-sinatra-app will not be available immediately.

## How does it work
This solution deploys a new EC2 instance based off Ubuntu's EC2 AMIs (found here: https://cloud-images.ubuntu.com/locator/ec2/) using CloudFormation.

CloudFormation assigns a SecurityGroup which permits traffic to only port 80 and port 22 from a CIDR range defined in cloudformation-params (default is 0.0.0.0/0).

The CloudFormation template has UserData defined to run commands which:
1. Add the saltstack apt repository
2. Download and install salt-minion and unzip
3. Download and extract this repository containing the Salt configurations
4. Run a Salt highstate to configure the server

Salt configurations are then used to:
1. Install the latest version of Apache2 and set it to run on startup
2. Configure an Apache vhost which performs a reverse proxy for the simple-sinatra-app
3. Installed ruby-bundler
4. Clones the rea-cruitment/simple-sinatra-app repository
5. Downloads the required dependencies as defined in the Gemfile
6. Defines a Systemd service unit for the simple-sinatra-app
7. Enables the simple-sinatra-app.service

## Design Choices
**CloudFormation**

CloudFormation was chosen as an easy and consistent way to provision an EC2 instance and other required resources quickly in a repeatable way. It also allows for bootstrapping of the configuration by a Configuration Management tool, such as Salt.

**Salt**

Salt was chosen as it is a Configuration Management tool capable of being run in a standalone environment, and the author was already familiar with it.

**Ubuntu**

Ubuntu was chosen as Canonical provide base AMIs for most regions which enables the CloudFormation template to be very flexible and to be reused in future.

**Security Group**

A Security Group was used to lockdown network access rather than configuring iptables/ufw on the host to maintain simplicity.

**SSH Lockdowns**

The SSH service has been locked down following guidelines from Mozilla (https://wiki.mozilla.org/Security/Guidelines/OpenSSH) and Center for Internet Security (https://benchmarks.cisecurity.org/downloads/benchmarks/)

The reader may find that they are unable to SSH to the host if they are using an older verison of OpenSSH, do not have a sufficiently strong key, or have not enabled support for newer ciphers. Consult the Mozilla link about for assistance, or SSH into the instance before Salt has configured these lockdowns.

## Short Comings / Future Improvements

 * An ELB could be configured to allow recovery of a failed host, allow additional hosts to be added to share the load, or allow deployments of new versions of software without an outage.
 * A Salt-master could be added to allow centralised control of a greater numbers of hosts as well as remote deployment of new/updated salt states.
 * Additional host lockdowns could be performed, such as following CIS (Center for Internet Security) Guidelines/Benchmarks. These were not performed to maintain the simplicity of the presented solution and due to the very small attack surface of the host.
 * HTTPS could be configured, and automated using Lets Encrypt, to protect the integrity and privacy of the web traffic. This was not performed as part of this solution to maintain simplicity, and as the task explicitly asked that the simple-sinatra-app be available on HTTP on port 80.
