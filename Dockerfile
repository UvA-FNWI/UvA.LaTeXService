FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

COPY . .
RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime AS runtime
RUN apt-get update && apt-get install -y texlive-xetex && apt-get --purge remove -y .\*-doc$

WORKDIR /app
COPY --from=build /app/out ./
COPY ./assets/. /tmp/
COPY ./fonts/. /usr/share/fonts/truetype/
ENTRYPOINT ["dotnet", "UvA.LaTeXService.dll"]