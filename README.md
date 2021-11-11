# Demo de Amphibian para HashiTalks América Latina 2021

Este repositorio no será modificado ni mantenido después del 11 de noviembre del 2021.

## Requisitos

* Tener [k3d](https://github.com/rancher/k3d) instalado.
* Tener [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) instalado.
* Tener Terraform versión [v0.13.5](https://releases.hashicorp.com/terraform/0.13.5/) instalado.

## Setup

* Corre `export KUBECONFIG=~/.k3d/k3s-default-config` primero, para evitar apuntar accidentalmente a otro cluster remoto.
* Corre `make start`. Esto va a crear un cluster k3d y va a instalar un cluster de un nodo de Consul, y los recursos necesarios para correr [Amphibian](https://github.com/patoarvizu/amphibian).
* Después de que termine el comando anterior, corre `make token` para desplegar el token del Consul que acabamos de crear. Copia y pega el `export ...` que se desplegó, o bien corre `eval $(make token)` para tener el token exportado en tu sesión de shell.

## Crear los recursos

Vamos a tener dos conjuntos de archivos de Terraform, uno para crear un certificado privado y otro para generar un password aleatorio. Es importante que para este demo, la versión de Terraform debe sea específicamente `0.13.5`, el resto de la documentación asume que el comando `terraform` usa esa versión.

* Entra al directorio `./terraform/password` y corre `terraform init`, seguido por `terraform apply -auto-approve`. Si todo funciona bien, debes de tener un mensaje que diga `Apply complete!`, y en los outputs verás `private_key = <sensitive>`.
* Entra al directorio `./terraform/tls`, y una vez más corre `terraform init`, seguido por `terraform apply -auto-approve`. Vas a ver el mismo mensaje de `Apply complete!`, pero ahora en los outputs outputs verás `password = <sensitive>`.

## Crea los objetos `TerraformState`

Como tenemos dos diferentes archivos de estado de Terraform (uno para `tls` y otro para `password`), los podemos representar y sincronizar con `Secret`s o `ConfigMap`s de Kubernetes por medio de custom resources (definidos cuando inicializamos el cluster) llamados `TerraformState`.

* Corre `kubectl apply -f ./manifests/password-state.yaml`.
* Corre `kubectl get secret password -o yaml` y debes de ver el password que fue generado por Terraform.
* Corre `kubectl apply -f ./manifests/tls-state.yaml`.
* Corre `kubectl get configmap tls -o yaml` y debes de ver el contenido del archivo de certificado privado que creamos con Terraform anteriormente.

## Limpieza

Cuando termines, simplemente corre `make destroy`, y el cluster de `k3d` va a ser destruído.