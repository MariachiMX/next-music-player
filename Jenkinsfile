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
                sh 'docker build -t web .'
            }
        }
stage('SonarQube analysis') {
    agent any // o un agente específico si lo necesitas (ej. con Node.js y Java)
    steps {
        script {
            def sonarScannerHome = tool 'sonar-scanner' // Obtiene la ruta del scanner configurado en Jenkins
            withSonarQubeEnv('SonarQube Server') {
                sh """
                    ${sonarScannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=001-Proyecto-nawicard-Evaluacion \
                        -Dsonar.projectName="001-Proyecto-nawicard-Evaluacion" \
                        -Dsonar.sources=. \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                        -Dsonar.exclusions=**/node_modules/**,**/*.test.js/** \
                        -Dsonar.scm.provider=git
                """
            }
        }
        //Calidad Gate
        waitForQualityGate abortOnError: true, credentialsId: 'SonarQube Server'
    }
}
        stage('Build and push Docker image') {
            steps {
                sh "docker tag web ${DOCKER_IMAGE}"
                    withCredentials([string(credentialsId: 'USER_DOCKERHUB', variable: 'DOCKER_TOKEN')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_TOKEN}"
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