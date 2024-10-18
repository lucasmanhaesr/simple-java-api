#Baixando imagem base do Maven para compilar o projeto Java e empacotá-lo em um arquivo JAR
FROM maven:3.9.8-eclipse-temurin-21 AS build
#Criando pasta em /opt
RUN mkdir /opt/app
#Copiando arquivos do projeto para a pasta criada
COPY . /opt/app
#Mudando o diretório padrão do container para a pasta criada
WORKDIR /opt/app
#Executando processo de limpeza e build
RUN mvn clean package
#Baixando uma nova imagem com a JDK 21 embarcada
FROM eclipse-temurin:21-jre-alpine
#Criando pasta em /opt
RUN mkdir /opt/app
#Baiando imagem base do JRE Alpine para manter a imagem final leve. O arquivo JAR é copiado para a nova imagem
COPY --from=build  /opt/app/target/app.jar /opt/app/app.jar
#Mudando o diretório padrão do container para a pasta criada
WORKDIR /opt/app
#Criando uma variável de ambiente com nome PROFILE e valor prd
ENV PROFILE=prd
#Expondo a porta 8080
EXPOSE 8080
# executando o projeto utilizando uma variavel especifica do java informando o PROFILE ativo que informamos anteriormente
ENTRYPOINT ["java", "-Dspring.profiles.active=${PROFILE}", "-jar", "app.jar"]