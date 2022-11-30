# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.
# AWS Credentials

# Rename this file to env.ps1 to run with the starter.
# See ../docs/ENVIRONMENT.md for more info about the environment variables.

# AWS Credentials
$env:AWS_ACCESS_KEY_ID=""
$env:AWS_SECRET_ACCESS_KEY=""
$env:AWS_SESSION_TOKEN=""
$env:AWS_DEFAULT_REGION="us-east-1"

# AWS Dependencies
$env:AWS_VPC_ID="" 
$env:AWS_LB_NAME=""  
$env:AWS_LB_HOSTNAME=""
$env:AWS_SG_ID=""

# AWS ECR/Docker
$env:AWS_ECR_URL="" 
$env:TAG="latest"

# Database config
$env:PGHOST = ""
$env:PGPORT = 5432
$env:PGUSER = "postgres"
$env:PGPASSWORD = ""

# Ed-Fi configuration
$env:COMPOSE_PROJECT_NAME="ed-fi-ecs"
$env:POPULATED_KEY="populatedKey"
$env:POPULATED_SECRET="populatedSecret"
$env:ENCRYPTION_KEY=(Invoke-Command "openssl rand -base64 32") ?? ""
$env:ADMIN_USER=""
$env:ADMIN_PASSWORD=""