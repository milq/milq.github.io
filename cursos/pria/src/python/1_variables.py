# Esto es un comentario de una línea

"""
   Esto es un comentario
   de múltiples líneas
"""

# VARIABLES
# Una variable es un símbolo que representa un valor que puede cambiar.
# En Python, simplemente asignamos un valor a una variable:
# nombre_variable = valor

edad = 25  # La edad es un número entero, no necesitamos especificar el tipo de dato


# TIPOS DE DATOS BÁSICOS

nivel_del_mar = 25                # Entero (int)
temperatura = -3.82               # Número real (float)
nombre = "Nacho López"            # Cadena de texto (str)
tiene_debian = True               # Booleano (bool): solo puede ser 'True' o 'False'


# OPERACIONES ARITMÉTICAS CON NÚMEROS

x = 5
y = 2

z = x + y          # Suma. Resultado: 7
z = x - y          # Resta. Resultado: 3
z = x * y          # Multiplicación. Resultado: 10
z = x / y          # División (siempre devuelve un 'float'). Resultado: 2.5
z = x // y         # División entera. Resultado: 2
z = x % y          # Módulo (resto de la división). Resultado: 1
z = z + 1          # Incrementa el valor de z en 1
z = z - 1          # Disminuye el valor de z en 1

# Puedes usar operadores abreviados (z += 1, z -= 1, z *= 2, z /= 3, etc):
z += 5             # Equivale a z = z + 5
z -= 2             # Equivale a z = z - 2


# OPERACIONES BÁSICAS CON CADENAS DE TEXTO (strings)

a = "GNU/"
b = "Linux"
c = a + b        # Concatenación. Resultado: "GNU/Linux"


# IMPRIMIR VARIABLES EN LA PANTALLA

print("¡Hola, mundo!")            # Imprime en la pantalla: ¡Hola, mundo!
print("El valor de x es", x)      # Imprime el valor de x

# Puedes imprimir en la pantalla cadenas de texto y variables
print("He comprado " + str(x) + " naranjas y " + str(y) + " limones.")
# O usando f-strings para mayor claridad (recomendado)
print(f"He comprado {x} naranjas y {y} limones.")


# CONVERSIÓN DE TIPOS DE DATOS

posicion = "5"                     # Una cadena que representa un número entero
calorias = "95.4"                  # Una cadena que representa un número real
peso = 85                          # Un número entero
altitud = -544.432                 # Un número real

# Convertir de cadena a entero
posicion_int1 = int(posicion)
print(f"Convertir 'posicion' de cadena a entero: {posicion_int1}")

# Convertir de cadena a número real (float)
calorias_flt1 = float(calorias)
print(f"Convertir 'calorias' de cadena a float: {calorias_flt1}")

# Convertir de número a cadena
peso_str1 = str(peso)
print(f"Convertir 'peso' de entero a cadena: '{peso_str1}'")

altitud_str1 = str(altitud)
print(f"Convertir 'altitud' de float a cadena: '{altitud_str1}'")

# Obtener el tipo de dato de las variables usando la función type()
tipo_posicion1 = type(posicion_int1)   # Tipo: <class 'int'>
tipo_calorias1 = type(calorias_flt1)   # Tipo: <class 'float'>
tipo_peso1 = type(peso_str1)           # Tipo: <class 'str'>
tipo_altitud1 = type(altitud_str1)     # Tipo: <class 'str'>

print(f"El tipo de 'posicion_int1' es {tipo_posicion1}")
print(f"El tipo de 'calorias_flt1' es {tipo_calorias1}")
print(f"El tipo de 'peso_str1' es {tipo_peso1}")
print(f"El tipo de 'altitud_str1' es {tipo_altitud1}")


# MENSAJE FINAL PARA EVITAR VARIABLES NO USADAS

print(f"Mi nombre es {nombre}, tengo {edad} años y estoy a {nivel_del_mar} metros sobre el nivel del mar, donde la temperatura es de {temperatura} grados Celsius. ¿Tengo Debian GNU/Linux instalado? {tiene_debian}. Y por cierto, el resultado de una división que hice antes es de {resultado_division}.")
