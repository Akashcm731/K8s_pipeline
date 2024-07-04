FROM maven:amazoncorretto as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM artisantek/tomcat:1
WORKDIR /app
RUN useradd -ms /bin/bash acm
RUN chown -R acm: /app /usr/local/tomcat/webapps
USER acm
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/
EXPOSE 8080
