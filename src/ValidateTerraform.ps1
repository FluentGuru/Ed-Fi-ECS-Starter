# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

$ErrorActionPreference = "Stop"

<#
    .SYNOPSIS
        Scans the subdirectories from the script location for Terraform modules, formats, validates.
#>

function Validate-TerraformModule {
    param (
        [Parameter()]
        [string]
        $TerraformRootPath = $PSScriptRoot
    )

    $fullPath = (Resolve-Path $TerraformRootPath).ToString().replace('\', '/')

    # Navigate in to module directory to run terraform commands
    pushd $fullPath
    try {
        terraform init
        terraform fmt
        terraform validate

        if ($LastExitCode -ne 0) {
            Write-Error "Error in Terraform code at $TerraformRootPath"
        }
    }
    finally {
        popd
    }

    if ($LastExitCode -ne 0) {
        Write-Error "Validation of Terraform for $TerraformRootPath failed"
    }
}

# Find all directories containing a .tf file that aren't within .terraform\
function Find-TerraformModules {
    param (
        [Parameter()]
        [string]
        $TerraformRootDirectory
    )
    $directories = Get-ChildItem $TerraformRootDirectory -Directory -Recurse | ? { $_.FullName -notmatch '.*\.terraform' }
    $directoriesWithTf = $directories | ? { (Get-ChildItem $_.FullName -File -Filter "*.tf").Count -gt 0 }

    return ($directoriesWithTf | ForEach-Object { $_.FullName })
}

$modulePaths = Find-TerraformModules -TerraformRootDirectory $PSScriptRoot

foreach ($tfModule in $modulePaths) {
    Validate-TerraformModule -TerraformRootPath $tfModule
}
