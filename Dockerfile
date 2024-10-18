#Instalando o Maven para a JDK 21
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
#Copiando o app.jar que foi gerado anteriormente em build para a pasta app e arquivo app.jar na nova imagem baixada
COPY --from=build  /opt/app/target/app.jar /opt/app/app.jar
#Mudando o diretório padrão do container para a pasta criada
WORKDIR /opt/app
#Criando uma variável de ambiente com nome PROFILE e valor prd
ENV PROFILE=prd
#Expondo a porta 8080
EXPOSE 8080
# executando o projeto utilizando uma variavel especifica do java informando o PROFILE ativo que informamos anteriormente
ENTRYPOINT ["java", "-Dspring.profiles.active=${PROFILE}", "-jar", "app.jar"]