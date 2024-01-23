# Despliegue de una aplicación MEAN multicapa

Este proyecto permite el despliegue de una aplicación MEAN tanto de forma local como en la nube utilizando los servicios de Amazon AWS.

## Despliegue local

En la carpeta `mean` se encuentra el archivo docker-compose.yaml el cual sirve para desplegar localmente tres servicios en contenedores:

- Una base de datos MongoDB: Aquí se almacenarán los mensajes enviados desde el frontend.
- el backend: Esta es una aplicación desarrollada en NodeJS y Express, y sirve de pasarela entre la base de datos y el frontend.
- el frontend: Esta es una aplicación desarrollada en Angular.

El despliegue es muy sencillo, sólo hay que ejecutar el siguiente comando:

```bash
docker-compose up -d --build
```

Esto dará inicio a la construcción de las imágenes de docker, una vez que termine de compilar las imágenes levantará los tres servicios. Para ver los logs de salida usaremos el comando:

```bash
docker-compose logs
```

## La versión de AWS

Para la versión de AWS hay que compilar las imágenes con packer. Los archivos de configuración se encuentran en la carpeta `packer` de este repositorio. El siguiente video muestra la compilación de las imágenes para AWS:

[![asciicast](https://asciinema.org/a/v5UC4r1rd3hJNVxZfa7WuQBmv.svg)](https://asciinema.org/a/v5UC4r1rd3hJNVxZfa7WuQBmv)

## Acerca de

Este proyecto ha sido desarrollado como parte de una tarea de la materia de Herramientas de DevOps, impartida por la universidad UNIR, como parte de la currícula de la maestría en desarrollo y operaciones de software.

Cualquier duda o comentario, no dudes en contactarme.
