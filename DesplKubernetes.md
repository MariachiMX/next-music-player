# Desplegar en KIND usando los comandos del pipeline de Jenkins

Este documento explica cómo instalar KIND (Kubernetes IN Docker) y ejecutar los comandos `kubectl` utilizados en tu pipeline de Jenkins para desplegar tu aplicación localmente.

## 1. Instalar KIND

Existen varias maneras de instalar KIND. La recomendada es usando `go install`:

*   **Requisitos:** Necesitas tener Go instalado en tu sistema. Puedes descargarlo desde [https://go.dev/dl/](https://go.dev/dl/).

*   **Instalación:** Abre una terminal y ejecuta:

    ```bash
    go install sigs.k8s.io/kind@v0.20.0 # Especifica la versión o usa la más reciente
    ```

    Asegúrate de que el directorio `$GOPATH/bin` esté en tu `$PATH`. Puedes añadirlo a tu archivo de configuración de shell (ej. `~/.bashrc`, `~/.zshrc`) con la siguiente línea:

    ```bash
    export PATH=$PATH:$(go env GOPATH)/bin
    ```

    Luego, reinicia tu terminal o ejecuta `source ~/.bashrc` (o el archivo que corresponda).

*   **Verificar la instalación:** Ejecuta:

    ```bash
    kind --version
    ```

    Esto debería mostrar la versión de KIND instalada.

## 2. Crear un clúster KIND

Una vez instalado KIND, crea un clúster con:

```bash
kind create cluster