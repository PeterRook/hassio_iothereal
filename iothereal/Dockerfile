#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
ARG SDK_IMAGE_ARCH_TAG
ARG RUNTIME_IMAGE_ARCH_TAG

FROM mcr.microsoft.com/dotnet/aspnet:$RUNTIME_IMAGE_ARCH_TAG AS base
RUN apk add --no-cache tzdata
WORKDIR /app
EXPOSE 4444

FROM mcr.microsoft.com/dotnet/sdk:$SDK_IMAGE_ARCH_TAG AS build
ARG BUILD_ARCH
WORKDIR /src
COPY ["iothereal.csproj", "."]
RUN dotnet restore "./iothereal.csproj" -r $BUILD_ARCH
COPY . .
WORKDIR "/src/."
RUN dotnet build "iothereal.csproj" -c Release -o /app/build -r $BUILD_ARCH

FROM build AS publish
ARG BUILD_ARCH
RUN dotnet publish "iothereal.csproj" -c Release -o /app/publish -r $BUILD_ARCH --no-self-contained  /p:EnvironmentName=Production

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "iothereal.dll"]

ARG VERSION
LABEL \
  io.hass.version="$VERSION" \
  io.hass.type="addon" \
  io.hass.arch="armhf|aarch64|amd64|armv7"
