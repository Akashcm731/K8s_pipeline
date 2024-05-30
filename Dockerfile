FROM maven:amazoncorretto as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM artisantek/tomcat:1
WORKDIR /app
COPY --from=build /app/target/*.war /usr/local/webapps/
EXPOSE 8080
