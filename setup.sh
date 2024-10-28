#!/bin/bash

# Configuración inicial
echo "Inicializando el entorno del proyecto Jenkins Pipeline"

# Paso 1: Clonar el repositorio (asume que se ejecuta desde la raíz del proyecto)
if [ ! -d ".git" ]; then
    echo "Clonando repositorio desde GitHub..."
    git init
    git remote add origin https://github.com/sandey2830/jenkins-pipeline-project.git
    git pull origin main
else
    echo "Repositorio ya inicializado."
fi

# Paso 2: Crear Dockerfile para Jenkins
echo "Creando Dockerfile para Jenkins..."
cat <<EOF > Dockerfile
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y docker.io
USER jenkins
EOF

# Paso 3: Crear archivo docker-compose.yml
echo "Creando archivo docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  jenkins:
    build: .
    container_name: jenkins
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
volumes:
  jenkins_home:
EOF

# Paso 4: Crear archivo Jenkinsfile
echo "Creando Jenkinsfile..."
cat <<EOF > Jenkinsfile
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
            }
        }
    }
}
EOF

# Paso 5: Crear README.md
echo "Creando README.md..."
cat <<EOF > README.md
# Jenkins Pipeline Project

Este proyecto configura un entorno Jenkins en Docker y ejecuta un pipeline como código (Pipeline as Code).

## Requisitos
- Docker
- Docker Compose
- Cuenta de GitHub con acceso al repositorio

## Pasos para ejecutar
1. Ejecuta \`./setup.sh\` para configurar el entorno.
2. Accede a Jenkins en \`http://localhost:8080\`.
3. Configura Jenkins para conectarse con GitHub y ejecutar el Pipeline.

## Descripción del Jenkinsfile
Este pipeline consta de tres stages: Build, Test y Deploy.

## Video Explicativo
[Enlace al video]
EOF

# Paso 6: Ejecutar Docker Compose para levantar Jenkins
echo "Iniciando Jenkins en Docker..."
docker-compose up -d

# Mensaje final
echo "Configuración completada. Accede a Jenkins en http://localhost:8080"
