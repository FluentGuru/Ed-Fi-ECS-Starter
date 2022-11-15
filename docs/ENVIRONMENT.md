# Ed-Fi ECS Starter environment variables

These are the environment variables needed to be setup to run the Ed-Fi ECS starter:

## AWS configuration

```
AWS_ACCESS_KEY_ID // your AWS account access key ID

AWS_SECRET_ACCESS_KEY // your AWS account secret key ID 

AWS_SESSION_TOKEN // your AWS session token (Only if using two factor authentication 2FA)

AWS_DEFAULT_REGION The AWS region where the starter is going to run (Defaults to us-east-1)
```

## AWS Dependencies

```
AWS_VPC_ID //ID of the VPC to be used by the starter

AWS_LB_NAME //Name of the load balancer to be used by the starter

AWS_LB_HOST //Hostname of the loadbalancer to be used by the starter

AWS_SG_ID //ID of the security group to be used by the starter

AWS_ECR_URL //url of the AWS ECR repository that will host the starter docker images.
```

## Database configuration

```
PGHOST //Hostname of the RDS postgreSQL instance to be used by the starter

PGPORT //port to use to connect to the RDS postgresSQL host

PGUSER //username to connect to the RDS postgresSQL host

PGPASSWORD //password to connect to the RDS postgresSQL host
```

## Ed-Fi configuration

```
COMPOSE_PROJECT_NAME //name of the starter deployment (Defaults to edfi-ecs)

POPULATED_KEY //key for encrypting Swagger authentications

POPULATED_SECRET //secret for encrypting Swagger authentications

ENCRYPTION_KEY //AES 32 bit key used by the admin app to encrypt credentials to access the API

ADMIN_USER // default adminapp username

ADMIN_PASSWORD // default adminapp password
```
