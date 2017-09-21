## sparkleformation-indigo-convert4free
This repository contains a SparkleFormation template that creates an 
auto scaling group of MZConvert EC2 instances.

Additionally, the template creates a Route53 (DNS) CNAME record:
convert4free.`ENV['public_domain']`.

### Dependencies

The template requires external Sparkle Pack gems, which are noted in
the Gemfile and the .sfn file.  These gems interact with AWS through the
`aws-sdk-core` gem to identify or create  availability zones, subnets, and 
security groups.

### Parameters

When launching the compiled CloudFormation template, you will be prompted for
some stack parameters:

| Parameter | Default Value | Purpose |
|-----------|---------------|---------|
| AllowRdpFrom | 127.0.0.1/32 | Lock down remote desktop access to the specified CIDR block |
| Convert4freeAssociatePublicIpAddress | false | No need to change |
| Convert4freeDeleteEbsVolumesOnTermination | true | Set to false if you want the EBS volumes to persist when the instance is terminated |
| Convert4freeDesiredCapacity | 1 | No need to change |
| Convert4freeEbsOptimized| false | Enable EBS optimization for the instance (instance type must be an m3, m4, c3 or c4 type; maybe others) |
| Convert4freeEbsProvisionedIops| 300 | Number of provisioned IOPS to request for io1 EBS volumes |
| Convert4freeEbsVolumeSize | 10 | Size (in GB) of additional EBS volumes |
| Convert4freeEbsVolumeType | gp2 | EBS volume type (gp2, or general purpose, or io1, provisioned IOPS).  Provisioned IOPS volumes incur additional expense. |
| Convert4freeInstanceMonitoring | false | Set to true to enable detailed cloudwatch monitoring (additional costs incurred) |
| Convert4freeInstanceType | t2.small | Increase the instance size for more network throughput |
| Convert4freeMaxSize | 1 | No need to change |
| Convert4freeMinSize | 0 | No need to change |
| Convert4freeNotificationTopic | auto-determined | No need to change |
| RootVolumeSize | 12 | No need to change |
| SshKeyPair | indigo-bootstrap | No need to change |
