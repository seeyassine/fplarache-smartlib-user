#FROM openjdk:17-oracle
#VOLUME /tmp
#COPY target/*.jar app.jar
#ENTRYPOINT ["java","-jar", "app.jar"]

# Use an intermediate Maven image to build the JAR file
FROM maven:3.8.6-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Use a lightweight OpenJDK image to run the application
FROM openjdk:17-oracle
VOLUME /tmp
COPY --from=build /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
