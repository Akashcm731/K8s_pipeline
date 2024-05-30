FROM maven:amazoncorretto as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM artisantek/tomcat:1
RUN useradd -ms /bin/bash admin
USER admin
RUN chmod 777 /app /usr/local/tomcat/webapps
WORKDIR /app
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
EXPOSE 8080
