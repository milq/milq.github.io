# //////////////////////////////////
# LISTAS EN PYTHON
# //////////////////////////////////

# CREAR UNA LISTA Y OBTENER ELEMENTOS DE ELLA

# En Python, una lista es una colección ordenada de elementos que pueden ser de diferentes tipos.
# Las listas son mutables, lo que significa que puedes modificarlas después de crearlas.

alimentos = ["naranjas", "fresas", "limones"]

# Acceder a elementos de la lista mediante su índice
# Nota: El índice en Python comienza desde 0
a = alimentos[0]
b = alimentos[1]
c = alimentos[2]

print(f"Me gustan las {a}, las {b} y los {c}")

# También puedes acceder a los elementos desde el final usando índices negativos
# Por ejemplo, alimentos[-1] devuelve el último elemento

# IMPRIMIR UNA LISTA

# Imprimir la lista directamente
print(alimentos)

# Usando el método join para convertir la lista en una cadena de texto
print(", ".join(alimentos))

# El método join concatena los elementos de la lista en una cadena,
# usando la cadena sobre la que se llama como separador.


# /////////////////////////////////////////////////////////////////////////////
# CONTAR ELEMENTOS EN UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

frutas = ["Manzana", "Plátano", "Sandía", "Melocotón", "Nectarina"]
num_frutas = len(frutas)
print(f"Número de frutas: {num_frutas}")

# La función len() devuelve el número de elementos en una lista.


# /////////////////////////////////////////////////////////////////////////////
# MODIFICAR UN ELEMENTO DE UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

edades = [43, 72, 32, 22, 65]

edades[3] = 57
edades[0] = 6
edades[-1] = 12  # Usando índice negativo para acceder al último elemento

# Convierte la lista de números a texto, los une con comas y los imprime
print(", ".join(map(str, edades)))

# Imprime directamente la lista, lo que muestra la lista con corchetes y sin formato.
print(edades)

# /////////////////////////////////////////////////////////////////////////////
# AÑADIR UN ELEMENTO A UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

nombres = ["Nacho", "David", "Lola"]

# Insertar "Alba" en la posición 2
nombres.insert(2, "Alba")

# Insertar "Álvaro" en la posición 0
nombres.insert(0, "Álvaro")

# Añadir "Marta" al final de la lista
nombres.append("Marta")

print(nombres)

# El método insert() inserta un elemento en una posición especificada.
# El método append() añade un elemento al final de la lista.

# /////////////////////////////////////////////////////////////////////////////
# ELIMINAR ELEMENTOS DE UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

colores = ["Azul", "Naranja", "Verde", "Amarillo", "Blanco"]

# Eliminar el elemento con índice 0
del colores[0]

# Eliminar el elemento con índice 2
del colores[2]

# Eliminar el último elemento
colores.pop()  # Elimina y devuelve el último elemento

print(colores)

letras = ["A", "B", "A", "B", "C", "B"]

# Eliminar la primera ocurrencia de "B"
letras.remove("B")

print("Después de eliminar la primera 'B': " + ", ".join(letras))

# Limpiar la lista
letras.clear()

print("Después de limpiar la lista de letras: " + ", ".join(letras))

# El método remove() elimina la primera coincidencia del elemento especificado.
# El método clear() elimina todos los elementos de la lista.

# /////////////////////////////////////////////////////////////////////////////
# ORDENAR UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

enteros = [43, 72, 32, 22, 65]
print("Lista de enteros antes de ordenar:")
print(enteros)

# Ordenar la lista en orden ascendente
enteros.sort()

print("Lista de números después de ordenar:")
print(enteros)

# El método sort() ordena la lista en su lugar.

# /////////////////////////////////////////////////////////////////////////////
# INVERTIR UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

animales = ["Perro", "Gato", "Pájaro", "Pez"]
print("Lista de animales antes de invertir:")
print(animales)

# Invertir el orden de los elementos
animales.reverse()

print("Lista de animales después de invertir:")
print(animales)

# El método reverse() invierte los elementos de la lista en su lugar.

# /////////////////////////////////////////////////////////////////////////////
# SUBLISTAS (SLICING)
# /////////////////////////////////////////////////////////////////////////////

lista_enteros = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Obtener una sublista que comienza en el índice 2 con 5 elementos
sub_lista = lista_enteros[2:7] # Desde el índice 2 hasta el 6 (ambos incluidos)

print("Sublista:")
print(sub_lista)

# El slicing te permite obtener una parte de la lista.
# Su sintaxis general es: lista[inicio:fin:paso]

# Si usas un paso negativo (-1), puedes recorrer la lista al revés:
lista_invertida = lista_enteros[::-1]

print("Lista invertida usando slicing [::-1]:")
print(lista_invertida)

# También puedes combinar slicing e índices para operaciones más específicas:
resultado = lista_enteros[3:7][::-1][2]

print("Resultado de lista_enteros[3:7][::-1][2]:", resultado)

# Explicación paso a paso:
# lista_enteros[3:7] -> [4, 5, 6, 7]     (del índice 3 al 6, ambos incluidos)
# [::-1] -> [7, 6, 5, 4]                 (invierte la sublista)
# [2] -> 5                     (toma el elemento con índice 2 de esa sublista)

# /////////////////////////////////////////////////////////////////////////////
# LISTAS VACÍAS
# /////////////////////////////////////////////////////////////////////////////

lista_vacia = []
print(f"La lista vacía tiene {len(lista_vacia)} elementos.")

# Puedes crear una lista vacía usando corchetes vacíos.

# /////////////////////////////////////////////////////////////////////////////
# LISTAS MULTIDIMENSIONALES
# /////////////////////////////////////////////////////////////////////////////

matriz = [
    ["a", "b", "c"],
    ["d", "e", "f"],
    ["g", "h", "i"]
]

print("Elemento en la posición (1,2) de la matriz:")
print(matriz[1][2])  # Devuelve "f"

# Las listas multidimensionales son listas de listas.

# /////////////////////////////////////////////////////////////////////////////
# LISTAS VACÍAS MULTIDIMENSIONALES
# /////////////////////////////////////////////////////////////////////////////

lista_vacia_multidimensional = []

# Añadir listas vacías a la lista multidimensional
lista_vacia_multidimensional.append([])
lista_vacia_multidimensional.append([])

print(f"La lista vacía multidimensional tiene {len(lista_vacia_multidimensional)} elementos.")

# /////////////////////////////////////////////////////////////////////////////
# SABER SI LA LISTA CONTIENE UN ELEMENTO
# /////////////////////////////////////////////////////////////////////////////

if "Alba" in nombres:
    print("Alba está en la lista de nombres.")
else:
    print("Alba no está en la lista de nombres.")

# El operador 'in' verifica si un elemento existe en una lista.

# /////////////////////////////////////////////////////////////////////////////
# OBTENER EL MÍNIMO Y MÁXIMO DE UNA LISTA
# /////////////////////////////////////////////////////////////////////////////

numeros = [5, 3, 8, 2, 6]
minimo = min(numeros)
maximo = max(numeros)

print(f"El número mínimo es: {minimo}")
print(f"El número máximo es: {maximo}")

# Las funciones min() y max() devuelven el menor y mayor elemento.

# /////////////////////////////////////////////////////////////////////////////
# SUMAR LOS ELEMENTOS DE UNA LISTA CON "SUM"
# /////////////////////////////////////////////////////////////////////////////

lista_numeros = [10, 20, 30, 40, 50]
suma_total = sum(lista_numeros)

print(f"La suma total de los números en la lista es: {suma_total}")

# La función sum() devuelve la suma de todos los elementos.

# /////////////////////////////////////////////////////////////////////////////
# TIPOS DE LISTAS EN PYTHON
# /////////////////////////////////////////////////////////////////////////////

# LISTA NUMÉRICA

numeros = [1, 2, 3, 4, 5]
# Los índices son numéricos y comienzan desde 0
print(numeros[0])  # Imprime 1

# DICCIONARIOS

persona = {
    "nombre": "Juan",
    "edad": 30,
    "ciudad": "Madrid"
}
# Accedemos a los elementos mediante claves
print(persona["nombre"])  # Imprime "Juan"

# DICCIONARIO COMBINADO

mi_diccionario = {
    0: 'valor índice 0',
    1: 'valor índice 1',
    2: 'valor índice 2',
    3: 'valor índice 3',
    4: 'valor índice 4',
    'clave0': 'valor clave 0',
    'clave1': 'valor clave 1',
    'clave2': 'valor clave 2',
    'clave3': 'valor clave 3',
    'clave4': 'valor clave 4',
}

# Este es un diccionario con claves numéricas y de cadena.
print(mi_diccionario["clave1"])  # Imprime "valor clave 1"
print(mi_diccionario[0])         # Imprime "valor índice 0"

# En Python, los diccionarios pueden tener claves de cualquier tipo inmutable.

# /////////////////////////////////////////////////////////////////////////////
# MÉTODOS Y FUNCIONALIDADES ADICIONALES DE LAS LISTAS EN PYTHON
# /////////////////////////////////////////////////////////////////////////////

# COPIAR UNA LISTA

# Copia superficial
lista_original = [1, 2, 3]
lista_copiada = lista_original.copy()

# Copia profunda (para listas anidadas)
import copy
matriz_copiada = copy.deepcopy(matriz)

# DESEMPAQUETADO DE LISTAS

a, b, c = alimentos
print(f"Valores desempaquetados: {a}, {b}, {c}")

# ASIGNACIÓN MÚLTIPLE

x, y = 10, 20
print(f"x = {x}, y = {y}")

# INTERCAMBIAR VARIABLES

x, y = y, x
print(f"Después de intercambiar: x = {x}, y = {y}")

# CONCATENAR LISTAS

lista1 = [1, 2, 3]
lista2 = [4, 5, 6]
concatenada = lista1 + lista2
print("Lista concatenada:", concatenada)

# REPETIR LISTAS

lista_repetida = [0] * 5
print("Lista repetida:", lista_repetida)

# COMPROBAR IGUALDAD DE LISTAS

lista_a = [1, 2, 3]
lista_b = [1, 2, 3]
print("Las listas son iguales:", lista_a == lista_b)

# Este es un resumen de las listas en Python. Hay muchas características más
# Recuerda que la práctica es clave para dominar las listas y sus operaciones.
