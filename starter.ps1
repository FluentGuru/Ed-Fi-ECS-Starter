# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

[CmdLetBinding()]
<#
#>
param(
    [ValidateSet("Build", "Publish", "Migrate", "Deploy", "Remove")]
    $Command = "Build"

)

Import-Module $PSScriptRoot\src\modules\yaml\PSYaml.psm1;
Import-Module $PSScriptRoot\src\modules\postgresql\PostgresqlCmdlets.psd1;

function Set-EdFiECSEnvironment {
    if (Test-Path "$PSScriptRoot\env.ps1") {
        Invoke-Expression "$PSScriptRoot\env.ps1"
        $env:ODSAPI_IMAGE = "$($env:AWS_ECR_URL)/api:$($env:TAG)"
        $env:SWAGGER_IMAGE = "$($env:AWS_ECR_URL)/swagger:$($env:TAG)"
        $env:ADMINAPP_IMAGE = "$($env:AWS_ECR_URL)/adminapp:$($env:TAG)"
    } else {
        Write-Error "no environment file configured"
    }
}

function Connect-ToEdFiECR {
    $ecrurl = $env:AWS_ECR_URL;
    $awsregion = $env:AWS_DEFAULT_REGION;
    docker login -u AWS -p $(aws ecr get-login-password --region $awsregion) $ecrurl
}

function Add-ECSContext (
    $name
) {
    docker context create ecs $name
}

function Invoke-Setup {
    Set-EdFiECSEnvironment
    Connect-ToEdFiECR
    Add-ECSContext $env:COMPOSE_PROJECT_NAME
}

function Invoke-BuildImage(
    $tag,
    $dir
) {
    docker build $dir -t $tag
}

function Invoke-Build {
    Use-DockerContext "default";
    Invoke-BuildImage $env:ODSAPI_IMAGE ./images/ods/ 
    Invoke-BuildImage $env:ADMINAPP_IMAGE ./images/adminapp/ 
    Invoke-BuildImage $env:SWAGGER_IMAGE ./images/swagger/ 
}

function Invoke-PublishImage(
    $tag
) {
    docker push $tag
}

function Invoke-Publish {
    Use-DockerContext "default";
    Invoke-PublishImage $env:ODSAPI_IMAGE
    Invoke-PublishImage $env:ADMINAPP_IMAGE    
    Invoke-PublishImage $env:SWAGGER_IMAGE   
}


function Add-EdFiAdminDb {
    Write-Host "Creating base Admin and Security databases...";
    "
    CREATE DATABASE IF NOT EXISTS EdFi_Admin TEMPLATE template0;
    CREATE DATABASE IF NOT EXISTS EdFi_Security TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Admin TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Security TO $POSTGRES_USER;
    "| psql --username "$POSTGRES_USER"  --port $POSTGRES_PORT --dbname "$POSTGRES_DB" --host "$ADMIN_POSTGRES_HOST"

}

function Add-EdFiODSDb {
    "
    CREATE DATABASE IF NOT EXISTS EdFi_Ods_Minimal_Template TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE EdFi_Ods_Minimal_Template TO $POSTGRES_USER;
    GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
    ALTER DATABASE EdFi_Ods_Minimal_Template OWNER TO $POSTGRES_USER; 
    " | psql --username "$POSTGRES_USER"  --port $POSTGRES_PORT --dbname "$POSTGRES_DB" --host "$ODS_POSTGRES_HOST"
}

function Publish-EdFiAdminDb {
    Write-Host "Loading Security Database from backup..."
    psql --no-password --username "$POSTGRES_USER"  --port $POSTGRES_PORT --dbname "EdFi_Security" --file ./src/migrations/EdFi_Security.sql --host "$ADMIN_POSTGRES_HOST"
    
    Write-Host "Loading Admin database from backup..."
    psql --no-password --username "$POSTGRES_USER"  --port $POSTGRES_PORT --dbname "EdFi_Admin" --file ./src/migrations/EdFi_Admin.sql --host "$ADMIN_POSTGRES_HOST"
    
    Write-Host "Running Admin App database migration scripts..."
    Get-ChildItem -Path "$PSScriptRoot/src/migrations/AdminApp" -Include "*.sql" | ForEach-Object {

    };
    for ($file in `./tmp/AdminAppScripts/PgSql/ | sort -V`
    do
        psql --no-password --username "$POSTGRES_USER" --port $POSTGRES_PORT --dbname "EdFi_Admin" --host "$ADMIN_POSTGRES_HOST" --file $FILE 1> /dev/null
    done
}

function Publish-EdFiODSDb {

}





function Invoke-Migrate {
    Write-Host "Starting database migration..."
}

function Use-DockerContext(
    $context
) {
    docker context use $context
}

function Deploy-EdFiECS {
    docker compose up
}

function Remove-Ed-FiECS {
    docker compose down
}

function Invoke-Deploy {
    Use-DockerContext $env:COMPOSE_PROJECT_NAME
    Deploy-DockerCompose
    Use-DockerContext "default"
}

function Invoke-Remove {
    Use-DockerContext $env:COMPOSE_PROJECT_NAME
    Remove-DockerCompose
    Use-DockerContext "default"
}

switch($Command) {
    Setup { Invoke-Setup }
    Build { Invoke-Build }
    Publish { Invoke-Publish }
    Migrate { Invoke-Migrate }
    Deploy { Invoke-Deploy }
    Remove { Invoke-Remove }
}