FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
RUN apt-get update && apt-get install -y texlive-xetex && apt-get --purge remove -y .\*-doc$

WORKDIR /app
COPY --from=build /app/out ./
COPY ./assets/. /tmp/
COPY ./fonts/. /usr/share/fonts/truetype/
ENTRYPOINT ["dotnet", "UvA.LaTeXService.dll"]