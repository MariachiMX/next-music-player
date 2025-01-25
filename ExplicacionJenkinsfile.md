# Explicación del Jenkinsfile

Este Jenkinsfile define un flujo de trabajo (pipeline) de Integración Continua/Entrega Continua (CI/CD) para una aplicación llamada "next-music-player". Automatiza los siguientes pasos:

## 1. `agent any`

Indica que el pipeline puede ejecutarse en cualquier agente (nodo) disponible de Jenkins.

## 2. `environment { ... }`

Define variables de entorno que estarán disponibles durante la ejecución del pipeline. En este caso, define `DOCKER_IMAGE` que construye el nombre completo de la imagen Docker usando el nombre del repositorio (`mariachimx/music-player`) y el número de build de Jenkins (`${BUILD_NUMBER}`). Por ejemplo, si el número de build es 5, `DOCKER_IMAGE` será `mariachimx/music-player:5`.

## 3. `stages { ... }`

Define las diferentes etapas del pipeline.

### 3.1. `stage('Checkout')`

*   **`git branch: 'DEV01', url: 'https://github.com/MariachiMX/next-music-player.git'`:** Clona el repositorio Git especificado en la URL, usando la rama `DEV01`.

### 3.2. `stage('SonarQube analysis')` (Opcional)

*   Esta etapa (actualmente comentada) se encarga del análisis estático de código con SonarQube.
*   **`def sonarScannerHome = tool 'sonar-scanner'`:** Obtiene la ruta al ejecutable del SonarQube Scanner configurado en Jenkins bajo el nombre `sonar-scanner`.
*   **`withSonarQubeEnv('SonarQube Server') { ... }`:** Configura el entorno para la conexión con el servidor SonarQube, usando las credenciales configuradas en Jenkins bajo el nombre `SonarQube Server`.
*   **`sh """ ... """`:** Ejecuta el escáner de SonarQube con las siguientes opciones:

    *   `-Dsonar.projectKey`: Clave del proyecto en SonarQube.
    *   `-Dsonar.projectName`: Nombre del proyecto en SonarQube.
    *   `-Dsonar.javascript.lcov.reportPaths`: Ruta al reporte de cobertura de código generado por las pruebas unitarias.
    *   `-Dsonar.sources`: Directorio que contiene el código fuente.
    *   `-Dsonar.exclusions`: Exclusiones para el análisis (ej. `node_modules`, archivos de prueba).
    *   `-Dsonar.scm.disabled=true`: Deshabilita la integración con el sistema de control de versiones.

*   `//waitForQualityGate ...`: Esta línea comentada se usaría para esperar a que el análisis de SonarQube complete y verificar el Quality Gate. Si el Quality Gate falla, el pipeline se detendría.

### 3.3. `stage('Build')`

*   **`sh 'docker-compose build'`:** Construye las imágenes Docker definidas en el archivo `docker-compose.yml` (si existe).
*   **`sh 'docker build -t web .'`:** Construye una imagen Docker a partir del Dockerfile en el directorio actual (`.`), etiquetándola como `web`.

### 3.4. `stage('Build and push Docker image')`

*   **`sh "docker tag web ${DOCKER_IMAGE}"`:** Etiqueta la imagen `web` con el nombre completo que incluye el repositorio y el número de build (ej. `mariachimx/music-player:5`).
*   **`withCredentials([usernamePassword(credentialsId: 'USER_DOCKERHUB', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) { ... }`:** Obtiene las credenciales de Docker Hub almacenadas en Jenkins con el ID `USER_DOCKERHUB` y las asigna a las variables de entorno `DOCKER_USERNAME` y `DOCKER_PASSWORD`.
*   **`sh "docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}"`:** Inicia sesión en Docker Hub usando las credenciales obtenidas.
*   **`sh "docker push ${DOCKER_IMAGE}"`:** Sube la imagen Docker etiquetada al registro de Docker Hub.

### 3.5. `stage('Deploy to KIND')`

*   Despliega la aplicación en un clúster KIND.
*   **`def deploymentYaml = """ ... """`:** Define un string con la configuración del Deployment de Kubernetes en formato YAML. Usa la variable `DOCKER_IMAGE` para especificar la imagen del contenedor.
*   **`writeFile file: 'deployment.yaml', text: deploymentYaml`:** Escribe la configuración del Deployment en un archivo llamado `deployment.yaml`.
*   **`sh 'kubectl apply -f deployment.yaml'`:** Aplica la configuración del Deployment al clúster KIND.
*   **`def serviceYaml = """ ... """`:** Define un string con la configuración del Service de Kubernetes en formato YAML.
*   **`writeFile file: 'service.yaml', text: serviceYaml`:** Escribe la configuración del Service en un archivo llamado `service.yaml`.
*   **`sh 'kubectl apply -f service.yaml'`:** Aplica la configuración del Service al clúster KIND.
*   **`sh 'kubectl get service music-player-service'`:** Obtiene información sobre el Service desplegado.
*   **`echo 'Despliegue en KIND exitoso!'`:** Imprime un mensaje de éxito.

En resumen, este Jenkinsfile automatiza la construcción, análisis (opcional), empaquetado en Docker, subida a Docker Hub y despliegue en un clúster KIND.