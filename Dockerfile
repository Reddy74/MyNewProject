FROM node:17.9.1 as base
WORKDIR /app
EXPOSE 80
EXPOSE 443
 
FROM node:17.9.1 AS build
WORKDIR /src
RUN npm install -g @angular/cli -g
COPY ./package.json .
RUN npm install
COPY . .
RUN ng build
#RUN ng build --prod

FROM nginx:1.17.1-alpine
#FROM nginx as runtime
COPY --from=build /app/dist/* /usr/share/nginx/html


#COPY ["DemoNetCoreWebAPI/DemoNetCoreWebAPI.csproj", "DemoNetCoreWebAPI/"]
#RUN dotnet restore "DemoNetCoreWebAPI/DemoNetCoreWebAPI.csproj"
#COPY . .
#WORKDIR "/src/DemoNetCoreWebAPI"
#RUN dotnet build "DemoNetCoreWebAPI.csproj" -c Release -o /app/build
 
#FROM build AS publish
#RUN dotnet publish "DemoNetCoreWebAPI.csproj" -c Release -o /app/publish

 
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "DemoNetCoreWebAPI.dll"]
