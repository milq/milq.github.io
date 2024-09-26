"""
Este script demuestra el uso de varias librerías estándar de Python para realizar operaciones matemáticas,
generar números aleatorios, trabajar con colecciones, manipular archivos y mostrar información en pantalla.
"""

# Importar módulos necesarios
import math      # Para funciones matemáticas avanzadas
import random    # Para generar números aleatorios
import os        # Para operaciones del sistema, como verificar si un archivo existe
import statistics  # Para cálculos estadísticos
import itertools   # Para combinaciones y permutaciones
from collections import Counter  # Para contar elementos

#########################################
# EJEMPLOS DE USAR LIBRERÍAS INTERNAS   #
#########################################

# MATEMÁTICAS (USANDO EL MÓDULO math)

# Variables de punto flotante
x = 5.0
y = 2.0

# Constantes matemáticas
pi = math.pi       # Constante π
e = math.e         # Constante e (Número de Euler)

print(f"Constante pi: {pi}")
print(f"Constante e: {e}")

# Operaciones matemáticas
potencia = math.pow(x, y)     # x elevado a la potencia y
exponencial = math.exp(x)     # e elevado a x
logaritmo = math.log(x)       # Logaritmo natural de x

print(f"{x} elevado a {y} es {potencia}")
print(f"e elevado a {x} es {exponencial}")
print(f"Logaritmo natural de {x} es {logaritmo}")

# Valor absoluto
valor_absoluto = abs(-x)
print(f"Valor absoluto de {-x} es {valor_absoluto}")

# Redondeo y funciones de piso y techo
redondeado = round(x)
piso = math.floor(x)
techo = math.ceil(x)

print(f"{x} redondeado es {redondeado}")
print(f"El piso de {x} es {piso}")
print(f"El techo de {x} es {techo}")

# Funciones trigonométricas (ángulos en radianes)
seno = math.sin(x)
coseno = math.cos(x)
tangente = math.tan(x)
arco_tangente = math.atan(x)
arco_tangente2 = math.atan2(y, x)

print(f"Seno de {x} es {seno}")
print(f"Coseno de {x} es {coseno}")
print(f"Tangente de {x} es {tangente}")
print(f"Arcotangente de {x} es {arco_tangente}")
print(f"Arcotangente2 de ({y}, {x}) es {arco_tangente2}")

# Máximo y mínimo
maximo = max(x, y)
minimo = min(x, y)

print(f"El máximo entre {x} y {y} es {maximo}")
print(f"El mínimo entre {x} y {y} es {minimo}")

# ALEATORIEDAD (USANDO EL MÓDULO random)

# Número flotante aleatorio entre 0 y 1
numero_aleatorio = random.random()
print(f"\nNúmero aleatorio entre 0 y 1 → {numero_aleatorio}")

# Número entero aleatorio entre dos valores, inclusivo
min_val = -3
max_val = 10
entero_aleatorio = random.randint(min_val, max_val)
print(f"Número entero aleatorio entre {min_val} y {max_val} → {entero_aleatorio}")

# Número flotante aleatorio entre dos valores
numero_aleatorio_flotante = random.uniform(min_val, max_val)
print(f"Número flotante aleatorio entre {min_val} y {max_val} → {numero_aleatorio_flotante}")

# COLECCIONES

# Lista de números de punto flotante
lista_de_flotantes = [1.5, 2.3, 3.7, 4.2, 5.9]

# Añadir elementos a la lista
lista_de_flotantes.append(6.1)
lista_de_flotantes.extend([7.4, 8.6, 9.0, 10.3])

print("\nLista de flotantes:")
print(lista_de_flotantes)

# Diccionario con claves de tipo string y valores de tipo float
diccionario_de_precios = {
    "Manzana": 0.75,
    "Pan": 1.50,
    "Leche": 2.99
}

# Añadir elementos al diccionario
diccionario_de_precios["Huevos"] = 1.99
diccionario_de_precios.update({"Queso": 3.49})

print("\nDiccionario de precios:")
for producto, precio in diccionario_de_precios.items():
    print(f"{producto} → {precio} €\t", end='')

# FILTRADO Y ORDENACIÓN (USANDO COMPRENSIONES DE LISTAS Y sorted)

# Filtrar elementos: obtener todos los números mayores que 5
mayores_que_cinco = [numero for numero in lista_de_flotantes if numero > 5.0]
print("\n\nNúmeros mayores que cinco:")
print(mayores_que_cinco)

# ESCRIBIR, LEER Y MOSTRAR ARCHIVOS DE TEXTO

nombre_archivo = 'texto.txt'
texto = "¡Hola, mundo!\n¡Esta es otra línea de texto!"

# Escribir texto en un archivo nuevo o sobrescribir si existe
with open(nombre_archivo, 'w', encoding='utf-8') as archivo:
    archivo.write(texto)

# Verificar si el archivo existe antes de leer
if os.path.exists(nombre_archivo):
    # Leer todo el texto del archivo
    with open(nombre_archivo, 'r', encoding='utf-8') as archivo:
        contenido = archivo.read()
else:
    contenido = ""
    print(f"El archivo {nombre_archivo} no existe.")

# Mostrar el contenido leído del archivo de texto
print("\nContenido del archivo de texto:")
print(contenido)


# DEMOSTRACIÓN DE OTRAS FUNCIONALIDADES

# Uso del módulo statistics para calcular estadísticas básicas
media = statistics.mean(lista_de_flotantes)
mediana = statistics.median(lista_de_flotantes)
desviacion = statistics.stdev(lista_de_flotantes)

print("\nEstadísticas de la lista de flotantes:")
print(f"Media: {media}\t", end='')
print(f"Mediana: {mediana}\t", end='')
print(f"Desviación estándar: {desviacion}")

# Uso del módulo collections para contar elementos
# Contar frecuencias de números redondeados
conteo_numeros = Counter(round(num) for num in lista_de_flotantes)
print("\nFrecuencia de números redondeados:")
for numero, frecuencia in conteo_numeros.items():
    print(f"Número: {numero}, Frecuencia: {frecuencia}; ", end='')

# Uso de itertools para combinaciones y permutaciones
# Obtener todas las combinaciones de 2 elementos de la lista de flotantes
combinaciones = list(itertools.combinations(lista_de_flotantes, 2))
print("\n\nCombinaciones de 2 elementos de la lista de flotantes:")
print(combinaciones)

# Obtener todas las permutaciones de 2 elementos de la lista de flotantes
permutaciones = list(itertools.permutations(lista_de_flotantes, 2))
print("\nPermutaciones de 2 elementos de la lista de flotantes:")
print(permutaciones)
