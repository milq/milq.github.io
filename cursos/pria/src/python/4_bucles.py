# ///////////////////
# BUCLES EN PYTHON //
# ///////////////////


# BUCLE CLÁSICO
print("BUCLE CLÁSICO")
for i in range(10):
    print(f"i:{i}\t", end='')
print("\n")

# En Python, el bucle 'for' se utiliza con 'range()' para iterar sobre una secuencia de números.



# BUCLE CLÁSICO CON LISTAS
print("BUCLE CLÁSICO CON LISTAS")
numeros = [-3.2, 5.3, 3.0, 1.0]
for i in range(len(numeros)):
    print(f"{numeros[i]}\t", end='')
print("\n")

# Es más común iterar directamente sobre los elementos:
print("BUCLE ITERANDO SOBRE ELEMENTOS DE LA LISTA")
for numero in numeros:
    print(f"{numero}\t", end='')
print("\n")



# BUCLE INVERSO
print("BUCLE INVERSO")
for i in range(5, -1, -1):
    print(f"i:{i}\t", end='')
print("\n")

# 'range(5, -1, -1)' genera números desde 5 hasta 0, decrementando en 1.



# BUCLE ANIDADO
print("BUCLE ANIDADO")
for i in range(3):
    print(f"i:{i}\t", end='')
    for j in range(2, 0, -1):
        print(f"j:{j}\t", end='')
        for k in range(2):
            print(f"k:{k}\t", end='')
print("\n")

# Los bucles anidados permiten iterar sobre múltiples niveles.



# BUCLE CON VARIOS CONTADORES
print("BUCLE CON VARIOS CONTADORES")
for a, b in zip(range(5), range(5, 0, -1)):
    print(f"a:{a} b:{b}\t", end='')
print("\n")

# 'zip()' combina dos secuencias, permitiendo iterar sobre ellas simultáneamente.



# BUCLE ITERADOR (VISTO ANTERIORMENTE)
print("BUCLE ITERADOR")
colores = ["rojo", "verde", "azul", "amarillo"]
for color in colores:
    print(f"{color}\t", end='')
print("\n")



# BUCLE WHILE
print("BUCLE WHILE")
contador = 0
while contador <= 3:
    contador += 1
    print(f"Hola {contador}\t", end='')
print("\n")

# El bucle 'while' ejecuta el bloque de código mientras la condición sea verdadera.



# EJEMPLO 1 (SUMATORIA)
print("EJEMPLO 1 (SUMATORIA)")
mi_lista = [-4.3, 2.0, -0.7, 1.5, 3.5]
suma = 0
for num in mi_lista:
    suma += num
print(f"La suma de todos los elementos de la lista es {suma}\n")

# Nota: También podríamos usar la función 'sum(mi_lista)' para obtener la suma.



# EJEMPLO 2 (PRODUCTO)
print("EJEMPLO 2 (PRODUCTO)")
lista_producto = [3.0, 2.0, -1.0, 1.0, 4.0]
producto = 1
for num in lista_producto:
    producto *= num
print(f"La multiplicación de todos los elementos de la lista es {producto}\n")

# Nota: A partir de Python 3.8, podemos usar 'math.prod(lista_producto)' para calcular el producto.



# EJEMPLO 3 (PRIMO)
print("EJEMPLO 3 (PRIMO)")
lista_enteros = [4, 8, 15, 16, 23, 42]
numero_primo = -1

for num in lista_enteros:
    es_primo = True
    if num <= 1:
        es_primo = False
    else:
        for divisor in range(2, int(num ** 0.5) + 1):
            if num % divisor == 0:
                es_primo = False
                break
    if es_primo:
        numero_primo = num
        break

if numero_primo != -1:
    print(f"El primer número primo en la lista es {numero_primo}\n")
else:
    print("No hay números primos en la lista.\n")



# EJEMPLO 4 (FACTORIAL)
print("EJEMPLO 4 (FACTORIAL)")
numero = 5
factorial = 1
for i in range(1, numero + 1):
    factorial *= i
print(f"El factorial de {numero} es {factorial}.\n")

# Alternativamente, podemos usar 'math.factorial(numero)' para calcular el factorial.



# EJEMPLO 5 (CREAR LISTAS CON BUCLES)
print("EJEMPLO 5 (CREAR LISTAS CON BUCLES)")
cuadrados = [x**2 for x in range(10)]
print(cuadrados)
