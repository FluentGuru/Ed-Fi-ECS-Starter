# Ed-Fi ECS starter AWS VPC and networking configuration

These are the following services needed to be configured for a network configuration fit for the Ed-Fi ECS Starter:

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

## How to create a VPC for the Ed-Fi Starter

1. Log in to your AWS account and go to the VPC console.
2. Click on "Create VPC".
3. At the top of the VPC Settings section choose "VPC and more".
4. At the "Name generation tag" field, write the name of your deployment (example: ed-fi-ecs).
5. at IPv4 CIDR block set `10.0.0.0/16`.
6. at IPv6 CIDR block choose "No IPv6 CIDR block.
7. Set "Number of Availability Zones (AZs)" to `2`.
8. Set "Number of public subnets" to `2`.
9. Set "Number of private subnets" to `2`.
10. Set "NAT Gateways ($)" to `1 per AZ`.
11. Set "VPC endpoints" to `S3 Gateway`.
12. On DNS options check `Enable DNS hostnames` and `Enable DNS resolution`.
13. Review your setup and click "Create VPC".

After following the guide you should be sent to a new page that will show you the progress of your VPC creation and after
a couple minutes your VPC is ready to use.

## How to get your VPC ID for the Ed-Fi ECS starter.

1. Log in to your AWS account and go to the VPC console.
2. On the left menu click on "Your VPCs".
3. On the list of all active VPCs find your VPC and click the checkbox.
4. On the pane that just opened below, look for the "VPC ID" field.
5. click on the copy icon .

## How to get your Security Group ID for the Ed-Fi ECS starter.

1. Log in to your AWS account and go to the VPC console.
2. On the left menu, in the "Security" sub menu click on "Security groups".
3. On the list of all active security groups find the one associated to your account and click the checkbox.
4. On the pane that just opened below, look for the "Security Group ID" field.
5. click on the copy icon.
