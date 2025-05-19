#!/bin/bash
# test-blog-api.sh
# Script para probar el servicio web RESTful de un blog usando HTTPie.
# Uso: bash test-blog-api.sh
#
# Requisitos:
#   - HTTPie CLI
#   - jq → sudo apt-get install jq

# Aquí defines la URL base del API del blog
# Esta es la que debes enviar al profesor en 'alwaysdata.txt'
BASE_URL="https://estudiante.alwaysdata.net/api"

TOTAL=0

divider() {
  echo -e "\n-----------------------------\n"
}

check_http_code() {
  local response="$1"
  local expected="$2"
  local mensaje="$3"
  local puntos="$4"
  local code=$(echo "$response" | grep -oE "HTTP/[0-9.]+ [0-9]{3}" | tail -1 | awk '{print $2}')
  if [[ "$code" == "$expected" ]]; then
    echo -e "\e[32m✅ $mensaje (HTTP $code) (+$puntos)\e[0m"
    TOTAL=$(echo "$TOTAL + $puntos" | bc)
  else
    echo -e "\e[31m❌ $mensaje (esperado $expected, recibido $code)\e[0m"
  fi
  divider
}

# 1. Obtener todos los artículos
echo "1. Obtener todos los artículos (http GET $BASE_URL/articulos)"
http GET "$BASE_URL/articulos"
check_http_code "$(http --print=Hh GET "$BASE_URL/articulos")" 200 "GET /articulos" 0.5

# 2. Crear artículo temporal y evaluar HTTP 201
echo "2. Crear un nuevo artículo temporal (http POST $BASE_URL/articulos ...)"
http POST "$BASE_URL/articulos" \
  titulo="Artículo temporal desde Bash" \
  contenido="Contenido de prueba automatizada" \
  fecha_publicacion="2025-03-15T08:00:00" \
  autor="Script Bash"

RESP2_BODY=$(http --print=b POST "$BASE_URL/articulos" \
  titulo="Artículo temporal desde Bash" \
  contenido="Contenido de prueba automatizada" \
  fecha_publicacion="2025-03-15T08:00:00" \
  autor="Script Bash")

check_http_code "HTTP/1.1 201 Created" 201 "POST /articulos" 1
ART_ID=$(echo "$RESP2_BODY" | jq -r '.id')
divider

# 3. Obtener el artículo recién creado
echo "3. Obtener el artículo recién creado (http GET $BASE_URL/articulos/$ART_ID)"
http GET "$BASE_URL/articulos/$ART_ID"
check_http_code "$(http --print=Hh GET "$BASE_URL/articulos/$ART_ID")" 200 "GET /articulos/$ART_ID" 1

# 4. Editar parcialmente el artículo
echo "4. Editar parcialmente el artículo (http PATCH $BASE_URL/articulos/$ART_ID ...)"
http PATCH "$BASE_URL/articulos/$ART_ID" \
  titulo="Título actualizado (PATCH)" \
  contenido="Contenido actualizado parcialmente"
check_http_code "$(http --print=Hh PATCH "$BASE_URL/articulos/$ART_ID" \
  titulo="Título actualizado (PATCH)" \
  contenido="Contenido actualizado parcialmente")" 200 "PATCH /articulos/$ART_ID" 1

# 5. Obtener todos los comentarios
echo "5. Obtener todos los comentarios (http GET $BASE_URL/comentarios)"
http GET "$BASE_URL/comentarios"
check_http_code "$(http --print=Hh GET "$BASE_URL/comentarios")" 200 "GET /comentarios" 0.5

# 6. Crear comentario en artículo y evaluar HTTP 201
echo "6. Crear un nuevo comentario en el artículo $ART_ID (http POST $BASE_URL/articulos/$ART_ID/comentarios ...)"
http POST "$BASE_URL/articulos/$ART_ID/comentarios" \
  contenido="Comentario desde Bash" \
  fecha_publicacion="2025-03-16T10:00:00" \
  autor="Usuario Bash"

RESP6_BODY=$(http --print=b POST "$BASE_URL/articulos/$ART_ID/comentarios" \
  contenido="Comentario desde Bash" \
  fecha_publicacion="2025-03-16T10:00:00" \
  autor="Usuario Bash")

check_http_code "HTTP/1.1 201 Created" 201 "POST /articulos/$ART_ID/comentarios" 1
COM_ID=$(echo "$RESP6_BODY" | jq -r '.id')
divider

# 7. Obtener el comentario creado
echo "7. Obtener el comentario creado (http GET $BASE_URL/comentarios/$COM_ID)"
http GET "$BASE_URL/comentarios/$COM_ID"
check_http_code "$(http --print=Hh GET "$BASE_URL/comentarios/$COM_ID")" 200 "GET /comentarios/$COM_ID" 1

# 8. Obtener comentarios del artículo
echo "8. Obtener todos los comentarios del artículo (http GET $BASE_URL/articulos/$ART_ID/comentarios)"
http GET "$BASE_URL/articulos/$ART_ID/comentarios"
check_http_code "$(http --print=Hh GET "$BASE_URL/articulos/$ART_ID/comentarios")" 200 "GET /articulos/$ART_ID/comentarios" 1

# 9. Editar completamente el comentario
echo "9. Editar completamente el comentario (PUT) (http PUT $BASE_URL/comentarios/$COM_ID ...)"
http PUT "$BASE_URL/comentarios/$COM_ID" \
  contenido="Comentario editado completamente desde PUT" \
  fecha_publicacion="2025-03-20T14:00:00" \
  autor="Nuevo Autor Bash"
check_http_code "$(http --print=Hh PUT "$BASE_URL/comentarios/$COM_ID" \
  contenido="Comentario editado completamente desde PUT" \
  fecha_publicacion="2025-03-20T14:00:00" \
  autor="Nuevo Autor Bash")" 200 "PUT /comentarios/$COM_ID" 1

# 10. Borrar el comentario
echo "10. Borrar el comentario (http DELETE $BASE_URL/comentarios/$COM_ID)"
http DELETE "$BASE_URL/comentarios/$COM_ID"
check_http_code "$(http --print=Hh DELETE "$BASE_URL/comentarios/$COM_ID")" 404 "DELETE /comentarios/$COM_ID" 1

# 11. Borrar el artículo
echo "11. Borrar el artículo (http DELETE $BASE_URL/articulos/$ART_ID)"
http DELETE "$BASE_URL/articulos/$ART_ID"
check_http_code "$(http --print=Hh DELETE "$BASE_URL/articulos/$ART_ID")" 404 "DELETE /articulos/$ART_ID" 1

# Resultado final
echo -e "\n🎓 Evaluación final para $USER.alwaysdata.net"
echo "PUNTUACIÓN TOTAL: $TOTAL / 10.0"
