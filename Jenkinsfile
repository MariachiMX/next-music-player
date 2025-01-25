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
        stage('SonarQube analysis') {
            steps {
                script {
                    def sonarScannerHome = tool 'sonar-scanner' // Obtiene la ruta del scanner configurado en Jenkins
                    withSonarQubeEnv('SonarQube Server') {
                        sh """
                            ${sonarScannerHome}/bin/sonar-scanner \
                                -Dsonar.projectKey=001-Proyecto-nawicard-Evaluacion \
                                -Dsonar.projectName="001-Proyecto-nawicard-Evaluacion" \
                                -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info \
                                -Dsonar.sources=. \
                                -Dsonar.exclusions=**/node_modules/**,**/*.test.js/** \
                                -Dsonar.scm.disabled=true
                        """
                    }
                }
        //Calidad Gate
        //waitForQualityGate abortOnError: true, credentialsId: 'SonarQube Server'
    }
}
        stage('Build') {
            steps {
                sh 'docker-compose build'
                sh 'docker build -t web .'
            }
        }
        stage('Deploy to KIND') {
            steps {
                script {
                    sh "kubectl apply -f yamls/deployment.yaml"
                    sh "kubectl apply -f yamls/service.yaml"

                    sh 'kubectl get service music-player-service'
                    echo 'Despliegue en KIND exitoso!'
                }
            }
        }
        
    }
}