packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Constructor de la AMI con MongoDB
build {
  name = "backend"

  # Mandamos llamar la configuración de lo que será la fuente inicial ed la AMI
  source "amazon-ebs.rhel" {
    ami_name = "unir-tarea-mean-backend"
  }

  # Copiamos el codigo fuente del backend a la AMI
  provisioner "file" {
    source      = "../mean/backend"
    destination = "/tmp/backend"
  }

  # Ejecutamos el script de instalación del backend
  provisioner "shell" {
    script = "files/backend.sh"
  }

  # Al finalizar, se guradarán los datos de la AMI creada en el archivo de manifiesto
  post-processor "manifest" {
    output = "manifest.json"
  }
}

# Constructor de la AMI con el Frontend
build {
  name = "frontend"

  # Mandamos llamar la configuración de lo que será la fuente inicial ed la AMI
  source "amazon-ebs.ubuntu" {
    ami_name = "unir-tarea-mean-frontend"
  }

  # Copiamos el archivo de configuración de Nginx a un directorio temporal
  provisioner "file" {
    source      = "../mean/frontend/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  # Copiamos el archivo de configuración del sitio MEAN a un directorio temporal
  provisioner "file" {
    source      = "../mean/frontend/mean.conf"
    destination = "/tmp/mean.conf"
  }

  # Copiamos el directorio con la aplicación compilada en un directorio temporal
  provisioner "file" {
    source      = "../mean/frontend/dist/frontend/browser"
    destination = "/tmp/browser"
  }

  # Copiamos los assets de la aplicación compilada en un directorio temporal
  provisioner "file" {
    source      = "../mean/frontend/src/assets"
    destination = "/tmp/assets"
  }

  # Ejecutamos el script de instalación del frontend
  provisioner "shell" {
    script = "files/frontend.sh"
  }

  # Al finalizar, se guradarán los datos de la AMI creada en el archivo de manifiesto
  post-processor "manifest" {
    output = "manifest.json"
  }
}
