
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
        stage('Build and push Docker image') {
            steps {
                sh "docker tag web ${DOCKER_IMAGE}"
                withCredentials([usernamePassword(credentialsId: 'USER_DOCKERHUB', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

stage('Deploy to KIND') {
    steps {
        script {
            def deploymentYaml = """
                apiVersion: apps/v1
                kind: Deployment
                metadata:
                  name: music-player
                  namespace: default
                spec:
                  replicas: 1
                  selector:
                    matchLabels:
                      app: music-player
                  template:
                    metadata:
                      labels:
                        app: music-player
                    spec:
                      containers:
                      - name: music-player
                        image: ${DOCKER_IMAGE}
                        ports:
                        - containerPort: 3000
            """

            writeFile file: 'deployment.yaml', text: deploymentYaml
            sh 'kubectl apply -f deployment.yaml'

            def serviceYaml = """
                apiVersion: v1
                kind: Service
                metadata:
                    name: music-player-service
                    namespace: default
                spec:
                    selector:
                        app: music-player
                    ports:
                        - protocol: TCP
                          port: 80
                          targetPort: 3000
                    type: LoadBalancer 
            """
             writeFile file: 'service.yaml', text: serviceYaml
            sh 'kubectl apply -f service.yaml'

            sh 'kubectl get service music-player-service'
            echo 'Despliegue en KIND exitoso!'
        }
    }
}
}
}