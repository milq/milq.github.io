#!/bin/bash
# test-blog-api.sh
# Script para probar el servicio web RESTful del blog usando HTTPie en Bash

echo "1. Obtener todos los artículos"
http GET https://estudiante.alwaysdata.net/articulos
echo -e "\n-----------------------------\n"

echo "2. Obtener el artículo con ID = 4"
http GET https://estudiante.alwaysdata.net/articulos/4
echo -e "\n-----------------------------\n"

echo "3. Crear un nuevo artículo"
http POST https://estudiante.alwaysdata.net/articulos \
    titulo='Nuevo título desde Bash' \
    contenido='Este es un artículo de prueba creado con HTTPie y Bash' \
    fecha_publicacion='2025-03-15T08:00:00' \
    autor='Nacho'
echo -e "\n-----------------------------\n"

echo "4. (PATCH) Editar parcialmente el artículo con ID = 4 (solo algunos campos)"
http PATCH https://estudiante.alwaysdata.net/articulos/4 \
    titulo='Título editado con PATCH' \
    contenido='Contenido parcial desde PATCH'
echo -e "\n-----------------------------\n"

echo "5. Borrar el artículo con ID = 4"
http DELETE https://estudiante.alwaysdata.net/articulos/4
echo -e "\n-----------------------------\n"

echo "6. Obtener todos los comentarios"
http GET https://estudiante.alwaysdata.net/comentarios
echo -e "\n-----------------------------\n"

echo "7. Obtener el comentario con ID = 5"
http GET https://estudiante.alwaysdata.net/comentarios/5
echo -e "\n-----------------------------\n"

echo "8. Obtener todos los comentarios del artículo con ID = 6"
http GET https://estudiante.alwaysdata.net/articulos/6/comentarios
echo -e "\n-----------------------------\n"

echo "9. Crear un nuevo comentario en el artículo con ID = 6"
http POST https://estudiante.alwaysdata.net/articulos/6/comentarios \
    contenido='Comentario desde Bash' \
    fecha_publicacion='2025-03-16T10:00:00' \
    autor='Usuario Nacho'
echo -e "\n-----------------------------\n"

echo "10. (PUT) Editar completamente el comentario con ID = 5 (todos los campos)"
http PUT https://estudiante.alwaysdata.net/comentarios/5 \
    contenido='Comentario totalmente editado desde PUT en Bash' \
    fecha_publicacion='2025-03-20T14:00:00' \
    autor='Nuevo Autor Nacho'
echo -e "\n-----------------------------\n"

echo "11. Borrar el comentario con ID = 5"
http DELETE https://estudiante.alwaysdata.net/comentarios/5
echo -e "\n-----------------------------\n"
