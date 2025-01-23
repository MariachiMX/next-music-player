pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "mariachimx/music-player:${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'DEV01', url: 'https://github.com/MariachiMX/next-music-player.git'
            }
        }
        stage('Build') {
            steps {
                sh 'docker-compose build'
            }
        }
//        stage('SonarQube analysis') {
//            steps {
//                withSonarQubeEnv('SonarQube Server') { // 'SonarQube Server' es el nombre configurado en Jenkins
//                    // Configuración del análisis de SonarQube para JavaScript
//                    sh '''
//                        sonar-scanner \
//                          -Dsonar.projectKey=001-Proyecto-nawicard-Evaluacion \
//                          -Dsonar.projectName="001-Proyecto-nawicard-Evaluacion" \
//                          -Dsonar.sources=. \
//                          -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \ // Ruta al reporte de cobertura (opcional)
//                          -Dsonar.exclusions=**/node_modules/**,**/*.test.js/** // Exclusiones (opcional)
//                    '''
//                }
//            }
//        }
        stage('Build and push Docker image') {
            steps {
                sh "docker tag web ${DOCKER_IMAGE}"
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }
        stage('Deploy') {
          steps {
            // Aquí iría la lógica de despliegue, que depende de tu entorno
            echo 'Imagen Docker desplegada'
          }
        }
    }
}