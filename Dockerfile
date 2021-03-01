#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["jenkins_t1/jenkins_t1.csproj", "jenkins_t1/"]
RUN dotnet restore "jenkins_t1/jenkins_t1.csproj"
COPY . .
WORKDIR "/src/jenkins_t1"
RUN dotnet build "jenkins_t1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "jenkins_t1.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "jenkins_t1.dll"]