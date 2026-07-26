#Requires -Version 5.0
<#
  Windows host launcher for compile-java.sh
  Mirrors the bash "host launcher" half of docker/compile-java.sh.
  The --inside half still runs as bash inside the container, unchanged.

  Usage:
    .\docker\compile-java.ps1
    .\docker\compile-java.ps1 src\be\openclinic\finance\Insurance.java
#>

$ErrorActionPreference = "Stop"

# Resolve repo root (parent of the folder this script lives in)
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

Push-Location $Root
try {
    # Check docker CLI exists
    $dockerCmd = Get-Command docker -ErrorAction SilentlyContinue
    if (-not $dockerCmd) {
        Write-Host "Docker is required (and Docker Desktop must be running)."
        exit 1
    }

    # Check docker daemon is reachable
    docker info *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker daemon is not reachable. Start Docker Desktop and retry."
        exit 1
    }

    Write-Host "==> Compiling inside tomcat:8.5-jdk8 (no host JDK needed)"

    # Convert the Windows-style root path to a Docker-friendly form (C:/Users/... style)
    $DockerRoot = $Root -replace '\\', '/'

    # Pass through any file args as-is; the --inside bash script already
    # normalizes backslashes to forward slashes for these.
    $extraArgs = $args

    docker run --rm `
        --platform linux/amd64 `
        -v "${DockerRoot}:/work" `
        -w /work `
        tomcat:8.5-jdk8 `
        bash /work/docker/compile-java.sh --inside @extraArgs

    exit $LASTEXITCODE
}
finally {
    Pop-Location
}
