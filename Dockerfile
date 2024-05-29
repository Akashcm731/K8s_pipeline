FROM maven:amazoncorretto as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:9
WORKDIR /app
COPY --from=build /app/target/app.jar ./app.jar
CMD ["java", "-jar", "app.jar"]
