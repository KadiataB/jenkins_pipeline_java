# Utilise une image JDK 21
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

# Copie le jar produit par Maven
COPY target/*.jar app.jar

# Expose le port Spring Boot par défaut
EXPOSE 8080

# Commande pour lancer l’application
ENTRYPOINT ["java","-jar","app.jar"]
