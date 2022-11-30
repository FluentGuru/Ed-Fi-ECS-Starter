# Overview

This document provides information about details and specifications of the Ed-Fi ECS Starter from tooling to AWS configuration.

## Tooling
These are the tools you need to install to work with the starter:

| Name      | Minimal version       | Required  |
|-----------|-----------------------|-----------|
| docker    | 18.x                  | Yes       |
| AWS CLI   | 2.7                   | Yes       |
| psql      | 15.0                  | Yes       |
| Powershell| 6.0                   | Yes       |

## Environment variables

These are the environment variables needed to be setup to run the Ed-Fi ECS starter:

### AWS configuration

```
AWS_ACCESS_KEY_ID // your AWS account access key ID

AWS_SECRET_ACCESS_KEY // your AWS account secret key ID 

AWS_SESSION_TOKEN // your AWS session token (Only if using two factor authentication 2FA)

AWS_DEFAULT_REGION The AWS region where the starter is going to run (Defaults to us-east-1)
```

### AWS Dependencies

```
AWS_VPC_ID //ID of the VPC to be used by the starter

AWS_LB_NAME //Name of the load balancer to be used by the starter

AWS_LB_HOST //Hostname of the loadbalancer to be used by the starter

AWS_SG_ID //ID of the security group to be used by the starter

AWS_ECR_URL //url of the AWS ECR repository that will host the starter docker images.
```

### Database configuration

```
PGHOST //Hostname of the RDS postgreSQL instance to be used by the starter

PGPORT //port to use to connect to the RDS postgresSQL host

PGUSER //username to connect to the RDS postgresSQL host

PGPASSWORD //password to connect to the RDS postgresSQL host
```

### Ed-Fi configuration

```
COMPOSE_PROJECT_NAME //name of the starter deployment (Defaults to edfi-ecs)

POPULATED_KEY //key for encrypting Swagger authentications

POPULATED_SECRET //secret for encrypting Swagger authentications

ENCRYPTION_KEY //AES 32 bit key used by the admin app to encrypt credentials to access the API

ADMIN_USER // default adminapp username

ADMIN_PASSWORD // default adminapp password
```

## Ed-Fi specifications

These are the specifications of the Ed-Fi deployment run by the starter:

### Versions

| Artifact  | Version   | Type    |
|-----------|-----------|---------|
| ODS API   | 5.3.1146  | Web App |
| Admin app | 2.3.2     | Web App |
| Swagger   | 5.3.1146  | Web App |

### Configurations
| Name           | Description                | Value          |
|----------------|----------------------------|----------------|
| Mode           | Deployment mode of Ed-Fi   | SharedInstance |
| DatabaseEngine | Database engine being used | PostgreSql     |
| TPDM Enabled   | Enabled TPDMN plugin       | True           |

## AWS Specifications

These are the specifications of the AWS deployment run by the starter:

### IAM Policies

These are the IAM policies required to run the starter:

```
application-autoscaling:*
cloudformation:*
ec2:AuthorizeSecurityGroupIngress
ec2:CreateSecurityGroup
ec2:CreateTags
ec2:DeleteSecurityGroup
ec2:DescribeRouteTables
ec2:DescribeSecurityGroups
ec2:DescribeSubnets
ec2:DescribeVpcs
ec2:RevokeSecurityGroupIngress
ecs:CreateCluster
ecs:CreateService
ecs:DeleteCluster
ecs:DeleteService
ecs:DeregisterTaskDefinition
ecs:DescribeClusters
ecs:DescribeServices
ecs:DescribeTasks
ecs:ListAccountSettings
ecs:ListTasks
ecs:RegisterTaskDefinition
ecs:UpdateService
elasticloadbalancing:*
iam:AttachRolePolicy
iam:CreateRole
iam:DeleteRole
iam:DetachRolePolicy
iam:PassRole
logs:CreateLogGroup
logs:DeleteLogGroup
logs:DescribeLogGroups
logs:FilterLogEvents
route53:CreateHostedZone
route53:DeleteHostedZone
route53:GetHealthCheck
route53:GetHostedZone
route53:ListHostedZonesByName
servicediscovery:*
```

### Networking configuration

These are the AWS networking services required by the starter:

| Service               | Count | Configuration                      |
|-----------------------|-------|------------------------------------|
| AWS VPC               | 1     | Site to client, Defaul tenancy     |
| Avaibility zones (AZ) | 2     |                                    |
| Public subnets        | 2     | One per AZ                         |
| Private subnets       | 2     | One per AZ                         |
| NAT Gateways          | 2     | One per AZ                         |
| Public route table    | 1     | One for all route tables           |
| Private route table   | 2     | One per private subnet             |
| Internet gateway      | 1     | One for the whole VPC              |
| Elastic IP            | 1     | One for the whole VPC              |
| S3 Gateway            | 1     | for docker container config        |

### RDS configuration

These are the RDS configuration required by the starter:

| Name                  | Description                    |
|-----------------------|--------------------------------|
| RDS instances         | One for the entire deployments |
| Engine                | PostgreSQL                     |
| Engine version        | 13.X                           |
| Multi-AZ              | Yes                            |
| Networking            | Same VPC as the starter        |
| Public access         | Yes during migration           |
| Instance class        | db.t3.medium or greater        |
| Storage               | Autoscalable, from 10-1000 gbi |

### Balancing and autoscaling

These are the configurations for load balancing and autoscaling produced by the starter:

| Name                  | Description                              |
|-----------------------|------------------------------------------|
| Application LB        | One for the entire deployment            |
| Application TG        | One for the entire deployment            |
| Auto-Scaling policy   | For the api, Min: 1, Max: 10, CPU: 75%   |
| API listener          | One listener targetting http://+:80      |
| Swagger listener      | One listener targetting http://+:8081    |
| Admin app listener    | One listener targetting http://+:8082    |

### DNS

The Ed-Fi ECS Starter creates CloudMap and Route53 resources for mapping and configuring service discovery and DNS hostnames. more information soon.