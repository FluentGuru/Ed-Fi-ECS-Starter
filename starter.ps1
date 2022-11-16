# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

[CmdLetBinding()]
<#
#>
param(
    [ValidateSet("Setup","Build", "Publish", "Migrate", "Deploy", "Remove")]
    $Command = "Build"

)

function Set-EdFiECSEnvironment {
    Write-Host "Loading environment..."
    if (Test-Path "$PSScriptRoot\env.ps1") {
        Invoke-Expression "$PSScriptRoot\env.ps1"
        $env:ODSAPI_IMAGE = "$($env:AWS_ECR_URL)/developersnet-edfi-api:$($env:TAG)"
        $env:SWAGGER_IMAGE = "$($env:AWS_ECR_URL)/developersnet-edfi-swagger:$($env:TAG)"
        $env:ADMINAPP_IMAGE = "$($env:AWS_ECR_URL)/developersnet-edfi-adminapp:$($env:TAG)"
        $env:API_URL = "http://$($env:AWS_LB_HOSTNAME)"
    } else {
        Write-Error "no environment file configured"
    }
}

function Connect-ToEdFiECR {
    Write-Host "Connecting to ECR '$($env:AWS_ECR_URL)' ..."
    $ecrurl = $env:AWS_ECR_URL;
    $awsregion = $env:AWS_DEFAULT_REGION;
    aws ecr get-login-password --region $awsregion | docker login -u AWS --password-stdin $ecrurl
}

function Add-ECSContext (
    $name
) {
    Write-Host "Creating docker ECS context ..."
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
    Invoke-BuildImage $env:ODSAPI_IMAGE ./src/images/ods/ 
    Invoke-BuildImage $env:ADMINAPP_IMAGE ./src/images/adminapp/ 
    Invoke-BuildImage $env:SWAGGER_IMAGE ./src/images/swagger/ 
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
@"
    CREATE DATABASE  "EdFi_Admin" TEMPLATE template0;
    CREATE DATABASE  "EdFi_Security" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Admin" TO $($env:PGUSER);
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Security" TO $($env:PGUSER);
"@| psql --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "postgres" --host "$($env:PGHOST)"

}

function Publish-EdFiAdminDb {
    Write-Host "Loading Security Database from backup..."
    psql --no-password --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "EdFi_Security" --file ./src/migrations/EdFi_Security.sql --host "$($env:PGHOST)"
    
    Write-Host "Loading Admin database from backup..."
    psql --no-password --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "EdFi_Admin" --file ./src/migrations/EdFi_Admin.sql --host "$($env:PGHOST)"
    
    Write-Host "Running Admin App database migration scripts..."
    Get-ChildItem -Path "$PSScriptRoot/src/migrations/AdminApp" -Include "*.sql" -Name | ForEach-Object {
        psql --no-password --username "$($env:PGUSER)" --port $($env:PGPORT) --dbname "EdFi_Admin" --host "$($env:PGHOST)" --file "$(Join-Path "$PSScriptRoot/src/migrations/AdminApp" $_)"
    };
}

function Add-EdFiODSDb {
    Write-Host "Creating ODS DB TPDM template"
@"
    CREATE DATABASE  "EdFi_Ods_Minimal_Template" TEMPLATE template0;
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods_Minimal_Template" TO $($env:PGUSER);
    GRANT ALL PRIVILEGES ON DATABASE postgres TO $($env:PGUSER);
    ALTER DATABASE "EdFi_Ods_Minimal_Template" OWNER TO $($env:PGUSER); 
"@| psql --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "postgres" --host "$($env:PGHOST)"
}



function Publish-EdFiODSDb {
    Write-Host "Creating ODS DB";
    psql --no-password --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "EdFi_Ods_Minimal_Template" --host "$($env:PGHOST)" --file "$PSScriptRoot/src/migrations/EdFi_Ods_Minimal_Template_TPDM_Core.sql"
@"
    CREATE DATABASE  "EdFi_Ods" TEMPLATE "EdFi_Ods_Minimal_Template";
    GRANT ALL PRIVILEGES ON DATABASE "EdFi_Ods" TO "$($env:PGUSER)";
"@ | psql --no-password --username "$($env:PGUSER)"  --port $($env:PGPORT) --dbname "postgres" --host "$($env:PGHOST)"
}

function Remove-EdFiDb {
Write-Host "Deleting Admin databases databases"
@"
DROP DATABASE IF EXISTS "EdFi_Admin" WITH (FORCE);
DROP DATABASE IF EXISTS "EdFi_Security" WITH (FORCE);
"@ | psql --username "$($env:PGUSER)"  --port "$($env:PGPORT)" --dbname "postgres" --host "$($env:PGHOST)"


Write-Host "Deleting ODS Databases databases databases"
@"
DROP DATABASE IF EXISTS "EdFi_Ods_Minimal_Template" WITH (FORCE);
DROP DATABASE IF EXISTS "EdFi_Ods" WITH (FORCE);
"@ | psql --username "$($env:PGUSER)"  --port "$($env:PGPORT)" --dbname "postgres" --host "$($env:PGHOST)"
}





function Invoke-Migrate {
    # Write-Host "Cleaning up DB"
    # Remove-EdFiDb
    Write-Host "Starting database migration..."
    Add-EdFiAdminDb
    Publish-EdFiAdminDb
    Add-EdFiODSDb
    Publish-EdFiODSDb
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
    Deploy-EdFiECS
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