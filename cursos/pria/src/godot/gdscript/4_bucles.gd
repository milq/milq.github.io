# ------------------
# BUCLES EN GDSCRIPT
# ------------------

@tool
extends EditorScript

func _run() -> void:

    # BUCLE CLÁSICO
    print("BUCLE CLÁSICO")
    var output: String = ""
    for i: int in range(10):
        output += "i:%d\t" % i
    print(output + "\n")

    # BUCLE CLÁSICO CON ARRAYS
    print("BUCLE CLÁSICO CON ARRAYS")
    var numeros: Array[float] = [-3.2, 5.3, 3.0, 1.0]
    output = ""
    for i: int in range(numeros.size()):
        output += "%f\t" % numeros[i]
    print(output + "\n")

    # BUCLE INVERSO
    print("BUCLE INVERSO")
    output = ""
    for i: int in range(5, -1, -1):
        output += "i:%d\t" % i
    print(output + "\n")

    # BUCLE ANIDADO
    print("BUCLE ANIDADO")
    output = ""
    for i: int in range(3):
        output += "i:%d\t" % i
        for j: int in range(2, 0, -1):
            output += "j:%d\t" % j
            for k: int in range(2):
                output += "k:%d\t" % k
    print(output + "\n")

    # BUCLE ITERADOR CON NÚMEROS (MUY UTILIZADO)
    print("BUCLE ITERANDO SOBRE ELEMENTOS DEL ARRAY")
    output = ""
    for numero: float in numeros:
        output += "%f\t" % numero
    print(output + "\n")

    # BUCLE ITERADOR CON STRINGS (MUY UTILIZADO)
    print("BUCLE ITERADOR")
    var colores: Array[String] = ["rojo", "verde", "azul", "amarillo"]
    output = ""
    for color: String in colores:
        output += "%s\t" % color
    print(output + "\n")

    # RECORRER UN ARRAY ANIDADO
    print("RECORRER UN ARRAY ANIDADO")
    var array_anidado: Array[Array] = [[1, 2], [3, 4], [5, 6]]
    output = ""
    for subarray: Array[int] in array_anidado:
        for elemento: int in subarray:
            output += "%d\t" % elemento
    print(output + "\n")

    # RECORRER UN DICCIONARIO
    print("RECORRER UN DICCIONARIO")
    var mi_diccionario: Dictionary = {
        "clave1": "valor1",
        "clave2": "valor2",
        "clave3": "valor3"
    }
    output = ""
    for clave in mi_diccionario.keys():
        var valor = mi_diccionario[clave]
        output += "%s: %s\t" % [clave, valor]
    print(output + "\n")

    # RECORRER UN DICCIONARIO ANIDADO
    print("RECORRER UN DICCIONARIO ANIDADO")
    var diccionario_anidado: Dictionary = {
        "usuario1": {"nombre": "Ana", "edad": 30},
        "usuario2": {"nombre": "Luis", "edad": 25}
    }
    output = ""
    for usuario_id in diccionario_anidado.keys():
        var datos_usuario = diccionario_anidado[usuario_id]
        output += "%s:\n" % usuario_id
        for clave in datos_usuario.keys():
            var valor = datos_usuario[clave]
            output += "  %s: %s\n" % [clave, valor]
    print(output)

    # BUCLE WHILE
    print("BUCLE WHILE")
    var contador: int = 0
    output = ""
    while contador <= 3:
        contador += 1
        output += "Hola %d\t" % contador
    print(output + "\n")

    # EJEMPLO 1 (SUMATORIA)
    print("EJEMPLO 1 (SUMATORIA)")
    var mi_lista: Array[float] = [-4.3, 2.0, -0.7, 1.5, 3.5]
    var suma: float = 0.0
    for num: float in mi_lista:
        suma += num
    print("La suma de todos los elementos es %f\n" % suma)

    # EJEMPLO 2 (PRODUCTO)
    print("EJEMPLO 2 (PRODUCTO)")
    var lista_producto: Array[float] = [3.0, 2.0, -1.0, 1.0, 4.0]
    var producto: float = 1.0
    for num: float in lista_producto:
        producto *= num
    print("El producto de todos los elementos es %f\n" % producto)

    # EJEMPLO 3 (PRIMO)
    print("EJEMPLO 3 (PRIMO)")
    var lista_enteros: Array[int] = [4, 8, 15, 16, 23, 42]
    var numero_primo: int = -1

    for num: int in lista_enteros:
        var es_primo: bool = true
        if num <= 1:
            es_primo = false
        else:
            for divisor: int in range(2, int(sqrt(num)) + 1):
                if num % divisor == 0:
                    es_primo = false
                    break
        if es_primo:
            numero_primo = num
            break

    if numero_primo != -1:
        print("El primer número primo del Array dado es %d\n" % numero_primo)
    else:
        print("No hay números primos en el Array dado.\n")

    # EJEMPLO 4 (FACTORIAL)
    print("EJEMPLO 4 (FACTORIAL)")
    var numero: int = 5
    var factorial: int = 1
    for i: int in range(1, numero + 1):
        factorial *= i
    print("El factorial de %d es %d.\n" % [numero, factorial])

    # Alternativamente, podríamos usar una función recursiva.

    # EJEMPLO 5 (CREAR ARRAYS CON BUCLES)
    print("EJEMPLO 5 (CREAR ARRAYS CON BUCLES)")
    var cuadrados: Array[int] = []
    for x: int in range(10):
        cuadrados.append(x * x)
    print(cuadrados)
