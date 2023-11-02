param(
    [Parameter(Mandatory)]
    [string]$version,

    [Parameter()]
    [switch]$signImages,

    [Parameter()]
    [string]$casApiKey
)

if ($signImages.IsPresent) {
    $env:CAS_API_KEY = $casApiKey
    & cas-v1.0.3-windows-amd64.exe login
}
##################  linux-x64
Write-Host "Building linux-x64"
docker build -t "ghcr.io/peterrook/amd64-hassiothereal:$($version)" --build-arg BUILD_ARCH=linux-x64 --build-arg SDK_IMAGE_ARCH_TAG=7.0-alpine --build-arg RUNTIME_IMAGE_ARCH_TAG=7.0.3-alpine3.17-amd64 . 

if ($signImages.IsPresent) {
    Write-Host "Signing linux-x64 Image"
    & cas-v1.0.3-windows-amd64.exe notarize --bom "docker://ghcr.io/peterrook/amd64-hassiothereal:$($version)"
}

Write-Host "Publishing linux-x64 Image"
docker push "ghcr.io/peterrook/amd64-hassiothereal:$($version)"

##################  linux-arm
Write-Host "Building linux-arm"
docker build -t "ghcr.io/peterrook/armv7-hassiothereal$($version)" --build-arg SDK_IMAGE_ARCH_TAG=7.0-alpine --build-arg RUNTIME_IMAGE_ARCH_TAG=7.0.3-alpine3.17-arm32v7 --build-arg BUILD_ARCH=linux-arm  .  
docker build -t "ghcr.io/peterrook/armhf-hassiothereal$($version)" --build-arg SDK_IMAGE_ARCH_TAG=7.0-alpine --build-arg RUNTIME_IMAGE_ARCH_TAG=7.0.3-alpine3.17-arm32v7 --build-arg BUILD_ARCH=linux-arm  . 

if ($signImages.IsPresent) {
    Write-Host "Signing linux-arm Images"
    & cas-v1.0.3-windows-amd64.exe notarize --bom "docker://ghcr.io/peterrook/armv7-hassiothereal$($version)"
    & cas-v1.0.3-windows-amd64.exe notarize --bom "docker://ghcr.io/peterrook/armhf-hassiothereal$($version)"
}
Write-Host "Publishing linux-arm Images"
docker push "ghcr.io/peterrook/armhf-hassiothereal$($version)"
docker push "ghcr.io/peterrook/armv7-hassiothereal$($version)" 

##################  linux-arm64
Write-Host "Building linux-arm64"
docker build -t "ghcr.io/peterrook/aarch64-hassiothereal$($version)" --build-arg SDK_IMAGE_ARCH_TAG=7.0-alpine --build-arg RUNTIME_IMAGE_ARCH_TAG=7.0.3-alpine3.17-arm64v8 --build-arg  BUILD_ARCH=linux-arm64 . 

if ($signImages.IsPresent) {
    Write-Host "Signing linux-arm64 Image"
    & cas-v1.0.3-windows-amd64.exe notarize --bom "docker://ghcr.io/peterrook/aarch64-hassiothereal$($version)"
}
Write-Host "Publishing linux-arm64 Image"
docker push "ghcr.io/peterrook/aarch64-hassiothereal$($version)"