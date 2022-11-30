# Overview

The Ed-Fi ECS Starter deploys and configure a deployment of Ed-Fi ODS in AWS using AWS Elastic container service. The starter allows you to setup a functional basic deployment with the minimal requirements in resources and security needed by Ed-Fi and the alliance so you can start using the ODS while also giving you room to customize it to serve your needs.

# Prerequisities

Before running the starter there are some prerrequisites you need to meet. Read the [Ed-Fi ECS Starter Specifications](./SPECS.md) to see if you meet the tooling and AWS IAM policy requirements.


# Setup AWS environment

Before deploying the starter, there are some services and dependencies needed to run. Here's how to create them:

## Create VPC

Ed-Fi ECS starter requires a Multi-AZ VPC to run with NAT and internet gateways to take inbound and outbount connections. Here's how to create them:

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

## Creating Elastic container registry

Ed-Fi ECS starter uses AWS Elastic Container Registry private repositories to host its custom images. Here's how to create them:

1. Log in to your AWS account and go to the Elastic Container Registry console.
2. On the left menu pane click on "Repositories"
3. You'll need to create three private repositories: `edfi-ods-api`, `edfi-ods-adminapp` and `edfi-ods-swagger`.
4. On the repository list click `Create Repository` and you'll be taken to the repository creation form
5. On "Visibility settings" choose `Private`
6. On "Repository name" write the name of the repository you are creating
7. Click `Create Repository`
8. Repeat steps 4-7 until You've created all the repositories.

## Create RDS instance

Ed-Fi ECS starter requires connection to a RDS PostgreSQL instance to manage the Ed-Fi Database. Here's how to create it:

1. Log in to your AWS account and go to the RDS console.
2. On the RDS console home click on `Create Database`.
3. On "Choose database creation method" select `Standard create`.
4. On "Engine options" choose `PostgreSQL`.
5. On "Engine version" choose `13.7-R1`.
6. On "Template" choose `Production`.
7. On "Avaibility and durability" choose `Multi-AZ DB Instance`.
8. Go to the "Settings" section and give your instance a name similar to your deployment but with the suffix `-rds`. example: `ed-fi-aws-rds`.
9. Create a master username and password for your instance and make sure to save the values.
10. Go to the "Instance configuration" section and on "Db instance class" choose `Burstable classes (includes t classes)`.
11. Select an instance class. Our minimum recommendation is `db.t3.medium` but you can choose `db.t3.large` or greater for maximum optimization.
12. Go to the "Storage" section and on "Storage type" choose `General purpose SSD (gp2)`
13. Set "Allocated storage" to `20`.
14. On "Storage Autoscaling" click the check `Enable storage autoscaling`.
15. Set "Maximum storage threshold" to `100`.
16. Go to the "Connectivity" section and on "Compute resource" choose `Do not connect to EC2 compute resource`.
17. on "Virtual private cloud (VPC)" select the VPC instance you created for the starter.
18. on "DB Subnet group" choose `default` or `Create new subnet group` if `default` doesn't exists.
19. on "Public access" choose `Yes` (Note. this is only for migrations, you can close public access after migrations ar complete).
20. On "VPC security group (firewall)" choose `Choose existing`.
21. "Existing VPC security groups" choose the default security group of your VPC.
22. Jump on the "Database authentication" section and on "Database authentication options" choose `Password and IAM database authentication`.
23. Finally go to the bottom of the page. and click `Create Database`.


## Create base load balancer

Ed-Fi ECS Starter requires a base Application Load balancer to work. Here's how to create it:

### Create Target Group

1. Log in to your AWS account and go to the EC2 console.
2. On the left menu pane search for the "Load balancing" section and click on "Target groups"
3. On the target groups list click on `Create Target Group`. you will be navigated to the Target Group creation form.
4. On the "Basic Configuration" section on the field "Choose target type" choose `Application Load Balancer`.
5. On "Target group name" Give it a name that is similar to your deployment but with the prefix `-tg`. Example `ed-fi-aws-tg`.
6. On "Protocol" and "Port" choose `HTTP` and set the port to `80`.
7. On "Protocol Version" choose `HTTP1`.
8. Go to the bottom of the page and click `Next`.
9. On the next page go to the bottom again and click `Create target group`.

### Create Application Load Balancer

1. Log in to your AWS account and go to the EC2 console.
2. On the left menu pane search for the "Load balancing" section and click on "Load balancers".
3. On the load balancers list click on `Create Load Balancer`. you will be navigated to the Load Balancer creation form.
4. On the first page click the `Create` button down the "Application Load Balancer" section.
5. On the next page. Fill out the name of the load balancer with a name that is similar to your deployment with the prefix `lb`. Example `ed-fi-aws-lb`.
6. On "Scheme" choose `Internet facing`.
7. On "IP Address type" choose `IPv4`.
8. On the "Networking Configuration" section choose the VPC you created for your deployment and select all the availability zones.
9. On the "Security groups" section choose the default Security group for your VPC.
10. On the "Listeners and routing section" go on "Select target group" choose the Target group you created on the previous section.
11. Go to the bottom of the page and click on `Create load balancer`.

Once you finish creating the necessary AWS services you are ready to setup your local environment!

# Setup local environment

To run the starter you need to setup the environment. This includes installing the necessary tooling, cloning the repository and setting up your environment variables.

## Install tooling

Ed-Fi ECS Starter requires certain tools to be installed on your machine. See [Ed-Fi-ECS Starter specifications to find](./SPECS.md) to find out more about these tools.

### Installing Git

to download the codebase of the starter you'll need Git. You can download it [here](https://git-scm.com/downloads) where you'll see a guide on how to download and install Git for your operative system. If you already have Git installed you can check if you have the correct version by running the command below on your terminal:

```
git --version
```

### Installing Powershell 

Ed-Fi ECS Starter uses Powershell scripts to manage the deployment. Powershell 6 or above is required. You can download Powershell [here](https://github.com/PowerShell/powershell/releases) where you'll see a guide on how to download and install Powershell for your operative system. If you already have Powershell run this command on your Powershell terminal to check if you have the correct version:

```
$PSVersionTable.PsVersion
```

### Installing Docker

Ed-Fi ECS Starter uses docker to build, publish and deploy docker containers for Ed-Fi's artifacts. Docker version 18 or greater is required. You can download Docker [here](https://www.docker.com/products/docker-desktop/) where you'll get a guide on how to download and install Docker for your operative system. If you already have Docker installed run this command to check if you have the correct version:

```
docker --version
```

### Installing the AWS CLI

Ed-Fi ECS Starter requires the AWS cli tool for interacting with AWS during deployment. Version 2.7 or greater is required. You can download the AWS cli [here](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) where you'll get a guide on how to download and install the AWS CLI for your operative system. If you already have the AWS cli installed you can check if you have the correct version with this command:

```
aws --version
```

### Installing PostgreSQL CLI

Ed-Fi ECS Starter uses PostgreSQL cli to interact with your RDS instance. Version 13 or greater is required. You can download the PostgreSQL CLI by following [this article](https://www.timescale.com/blog/how-to-install-psql-on-mac-ubuntu-debian-windows/) where you'll learn how to download and install PostgreSQL CLI for your operative system. If you already have it installed you can check if you have the correct version by running the following commands:

```
psql --version
```

## cloning your repository.

Once you installed all the necessary tools you can clone your repository. create a folder to host the codebase and open the terminal there to run this command.

```
git clone https://github.com/Ed-Fi-Exchange-OSS/Ed-Fi-ECS-Starter.git .
```

After it runs you'll see all the files of the starter in your directory.

## Setup environment variables

Ed-Fi ECS Starter uses environment variables for its configuration. the variables are configured through a powershell files that acts similar as an `.env` file.

### the env.ps1 file

On the starter codebase you'll see a file called `env.example.ps1`. duplicate that file and rename it to `env.ps1`. now you have to set the values of these environment variables. Here's an example on how it should look like:

```
# AWS Credentials
$env:AWS_ACCESS_KEY_ID="YOUR ACCESS ID"
$env:AWS_SECRET_ACCESS_KEY="YOUR ACCESS SECRET"
$env:AWS_SESSION_TOKEN="YOUR SESSION TOKEN (if using 2FA on your AWS account)"
$env:AWS_DEFAULT_REGION="us-east-1"

# AWS Dependencies
$env:AWS_VPC_ID="vpc-0fcf208e6ecec4037" 
$env:AWS_LB_NAME="developersnet-edfi-shared-elb"  
$env:AWS_LB_HOSTNAME="developersnet-edfi-shared-elb-1258834677.us-east-1.elb.amazonaws.com"
$env:AWS_ECR_URL="055640809004.dkdr.ecr.us-east-1.amazonaws.com" 
$env:AWS_SG_ID="sg-092d75beef47937ff"

# AWS ECR/Docker
$env:TAG="latest"

# Database config
$env:PGHOST = "developersnet-edfid-shared-ods-rds.ckljvufeppno.us-east-1.rds.amazonaws.com"
$env:PGPORT = 5432
$env:PGUSER = "postgres"
$env:PGPASSWORD = "postgres1"

# Ed-Fi configuration
$env:COMPOSE_PROJECT_NAME="developersnet-edfi-shared"
$env:POPULATED_KEY="populatdedKey"
$env:POPULATED_SECRET="populateddSecret"
$env:ENCRYPTION_KEY="r2bemkTvjsRURdur0+dc49eaON140QRkQzgQwPdht8Lk="
$env:ADMIN_USER="admin@test.com"
$env:ADMIN_PASSWORD="Admin41
```

### Getting AWS dependencies.

Some of the environment variables reference AWS services you created for the started (See [Specification](./SPECS.md) for more details). The environment variables related to these services are:

```
AWS_VPC_ID //ID of the VPC to be used by the starter

AWS_LB_NAME //Name of the load balancer to be used by the starter

AWS_LB_HOST //Hostname of the loadbalancer to be used by the starter

AWS_SG_ID //ID of the security group to be used by the starter

AWS_ECR_URL //url of the AWS ECR repository that will host the starter docker images.
```

To get your VPC ID:
1. Log in to your AWS account and go to the VPC console.
2. On the left menu click on "Your VPCs".
3. On the list of all active VPCs find your VPC and click the checkbox.
4. On the pane that just opened below, look for the "VPC ID" field.
5. click on the copy icon .

To get your Security Group ID:
1. Log in to your AWS account and go to the VPC console.
2. On the left menu, in the "Security" sub menu click on "Security groups".
3. On the list of all active security groups find the one associated to your account and click the checkbox.
4. On the pane that just opened below, look for the "Security Group ID" field.
5. click on the copy icon.

to get your Application load balancer name and host:
1. Log in to your AWS account and go to the EC2 console.
2. On the left menu, in the "Load balancing" sub menu click on "Load balancers".
3. On the list of load balancers click the checkbox of your load balancer.
4. On the pane that just opened below, look for the name of your load balancer and your hostname
5. Copy the values.

to get your ECR repository URL:
1. Log in to your AWS account and go to the Elastic Container Registry console.
2. On the list of private repositories select one of the repositories you created for the starter
3. Copy the hostname part of the URI for the repository you selected. For example, if the URI of your repository is `055640809003.dkr.ecr.us-east-1.amazonaws.com/developersnet-edfi-adminapp` you should only copy `055640809003.dkr.ecr.us-east-1.amazonaws.com`

### Getting ENCRYPTION_KEY
the `ENCRYPTION_KEY` environment variable must be filled with a AEC 32bit synchronous key value. you can create one with `openssl` by running the following command:

```
openssl rand -base64 32
```

### Running the setup.
Once you filled out all the values in the `env.ps1` file, open your Powershell terminal at the root of the Starter codebase and run the following command:

```
.\starter.ps1 Setup
```

This command creates the following components in your environment:
- A Docker context for ECS deployment
- A Docker connection to your ECR repository
- A setup of the ECS environment variables

Once you setup the starter you can start building and publishing your images.

## Build and publish images

Once you setup the starter you can build and publish the Docker images for the deployment. You can build the images with the starter by running the following command on your Powershell console:

```
.\starter.ps1 Build
```

This will build all the starter images in your command tagged to your ECR repository which you can then push running the following command:

```
.\starter.ps1 Publish
```

With this the Starter Docker images will be available in your AWS environment and ready for deployment.


## Run migrations

Before deploying the Starter you need to run the Ed-Fi ODS Database migrations against your RDS instance make sure that you have configured your database correctly on your `env.ps1` file and have run the Starter setup. These are the environment variables required for migrations:

```
PGHOST //Hostname of the RDS postgreSQL instance to be used by the starter

PGPORT //port to use to connect to the RDS postgresSQL host

PGUSER //username to connect to the RDS postgresSQL host

PGPASSWORD //password to connect to the RDS postgresSQL host
```

### Testing your connection to your RDS instance

When creating your RDS instance we mentioned that we initially configured the instance to be publicly accessible, this is to ensure that the Starter can run migrations from your machine. To test that you can connect to your RDS instance run the following command on your powershell terminal after you setup the starter:

```
.\starter.ps1 TestDB
```

if successful you should see `CONNECTION SUCCEED` as the output

### Running migrations

To run migrations agains the database run the followin command on your Powershell console.

```
.\starter.ps1 Migrate
```

This command should take between 20-30 minutes depending on your bandwidth to execute but after that your RDS instance will be up to date with all Ed-Fi database artifacts.

## Run deployment

Finally! you are ready to deploy the starter to your AWS environment. to run the deployment run this command on your Powershell console

```
.\starter.ps1 Deploy
```

This command will take a couple minutes to finish but when it's done Ed-Fi will be deployed and ready to use in an ECS cluster.

### Testing your deployment.

To test your deployment open your browser and go to the address of your Ed-Fi ECS Starter Load balancer hostname. with this you can test the following:
 
- On port `:80` you shold be able to access the ODS API
- On port `:8081` you should be able to access the ODS Swagger instance
- On port `:8082` you should be able to access the ODS Admin app

Finally, test the deployment by creating an Application on the Admin application.

# Tear down

If you want to tear down your deployment you can do it by running the following command on your Powershell console:

```
.\starter.ps1 Remove
```

This command will remove your Ed-Fi ECS cluster, the CloudMap and Route53 entries and will reset your load balancer and security group rules. Your VPC, RDS and ECR resources will remain intact.

# Extending and customizing

Now that your starter is up and working you can start customizing and extending your deployment. Here are a couple of extensions and customizations you can add to your deployment:

## Adding an API gateway
--TODO--

## using a custom domain
--TODO--

## Adding autoscaling to the ODS API
--TODO--

## Adding DataImport to your deployment
--TODO--

## Adding DataChecker to your deployment.
--TODO--

