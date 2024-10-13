# ------------------
# ARRAYS EN GDSCRIPT
# ------------------

@tool
extends EditorScript

func _run() -> void:
    # CREAR UN ARRAY

    # En GDScript, un Array es una colección ordenada de elementos

    # Array sin tipo explícito: puede contener múltiples tipos de datos
    # y la variable 'mi_array_1' puede reasignarse a otro tipo en el futuro.
    var mi_array_1 = ["texto", 123, 45.67]

    # Array con tipo explícito 'Array': también acepta varios tipos de datos,
    # pero la variable 'mi_array_2' será un Array y no podrá cambiar de tipo.
    var mi_array_2: Array = ["texto", 123, 45.67]

    # Array con tipo explícito 'Array' de 'String': solo acepta un tipo de dato
    var alimentos: Array[String] = ["naranjas", "fresas", "limones"]

    # ACCEDER A SUS ELEMENTOS E IMPRIMIR UN ARRAY

    # Acceder a elementos del Array mediante su índice
    # Nota: El índice en GDScript comienza desde 0 (primer elemento)
    var a: String = alimentos[0]
    var b: String = alimentos[1]
    var c: String = alimentos[2]

    print("Me gustan las %s, las %s y los %s." % [a, b, c])

    # También puedes acceder a los elementos desde el final usando índices
    # negativos. Por ejemplo, alimentos[-1] devuelve el último elemento
    print("Sí, me gustan los %s." % alimentos[-1])

    # Imprimir el Array completo directamente
    print(alimentos)

    # Imprimir varios Arrays seguidos
    print(mi_array_1, mi_array_2)

    # CONTAR ELEMENTOS EN UN ARRAY

    var frutas: Array[String] = ["Manzana", "Plátano", "Kiwi", "Pera", "Lima"]
    var num_frutas: int = frutas.size()    # Devuelve el número de elementos
    print("Número de frutas: %d" % num_frutas)

    # MODIFICAR UN ELEMENTO DE UN ARRAY

    var edades: Array[int] = [43, 72, 32, 22, 65]

    edades[3] = 57
    edades[0] = 6
    edades[-1] = 12  # Usando índice negativo para acceder al último elemento

    print(edades)

    # AÑADIR UN ELEMENTO A UN ARRAY

    var nombres: Array[String] = ["Nacho", "David", "Lola"]

    # Insertar "Alba" en la posición 2
    nombres.insert(2, "Alba")

    # Insertar "Álvaro" al inicio del Array
    nombres.push_front("Álvaro")    # También vale nombres.insert(0, "Álvaro")

    # Añadir "Marta" al final del Array
    nombres.append("Marta")      # También vale nombres.push_back("Marta")

    print(nombres)

    # ELIMINAR ELEMENTOS DE UN ARRAY

    var colores: Array[String] = ["Azul", "Naranja", "Verde", "Lila", "Blanco"]

    print("Array de colores antes de eliminar elementos: ", colores)

    # Eliminar sin devolver el elemento con índice 2
    colores.remove_at(2)
    print("Se ha eliminado el elemento con índice 2")

    # Eliminar y devolver un elemento específico del Array
    var tercer_elemento:String = colores.pop_at(2)
    print("El tercer elemento eliminado es el color: ", tercer_elemento)

    # Eliminar y devolver el primer elemento
    var primer_elemento: String = colores.pop_front()
    print("El primer elemento eliminado es el color: ", primer_elemento)

    # Eliminar y devolver el último elemento
    var ultimo_elemento: String = colores.pop_back()
    print("El último elemento eliminado es el color: ", ultimo_elemento)

    print("Array de colores después de eliminar elementos: ", colores)

    var abecedario: Array[String] = ["A", "C", "B", "C", "D", "E"]

    # Eliminar la primera ocurrencia de "C"
    abecedario.erase("C")

    print("Después de eliminar la primera 'C': " + str(abecedario))

    # Limpiar el array
    abecedario.clear()

    print("Después de limpiar el Array del abecedario: " + str(abecedario))

    # ORDENAR UN ARRAY

    var enteros: Array[int] = [43, 72, 32, 22, 65]
    print("Array de enteros antes de ordenar:")
    print(enteros)

    # Ordenar el array en orden ascendente
    enteros.sort()

    print("Array de números después de ordenar:")
    print(enteros)

    # INVERTIR UN ARRAY

    var animales: Array[String] = ["Perro", "Gato", "Pájaro", "Pez"]
    print("Array de animales antes de invertir:")
    print(animales)

    # Invertir el orden de los elementos
    animales.reverse()

    print("Array de animales después de invertir:")
    print(animales)

    # SUBARRAYS (SLICING)

    var letras: Array[String] = ["A", "B", "C", "D", "E", "F"]

    # Slice devuelve un nuevo Array que contiene los elementos de este array,
    # desde el índice inicio (incluido) hasta el índice fin (excluido).
    var subletras: Array[String] = letras.slice(1, 3)

    print(subletras)  # Imprime ["B", "C"]

    # Ejemplos de uso de 'slice':
    print(letras.slice(2, -2))       # Imprime ["C", "D"]
    print(letras.slice(-2, 6))       # Imprime ["E", "F"]
    print(letras.slice(0, 6, 2))     # Imprime ["A", "C", "E"] (cada dos pasos)
    print(letras.slice(4, 1, -1))    # Imprime ["E", "D", "C"] (pasos al revés)

    # ARRAYS VACÍOS

    var array_vacio: Array = []
    print("El array vacío tiene %d elementos." % array_vacio.size())

    # ARRAYS MULTIDIMENSIONALES

    var array_multidimensional: Array[Array] = [
        ["a", "b", "c"],
        ["d", "e", "f"],
        ["g", "h", "i"]
    ]

    print("Elemento en la posición (2, 1) del Array multidimensional:")
    print(array_multidimensional[2][1])  # Devuelve "h"

    # Los Arrays anidados con tipos no son compatibles en GDScript por ahora.
    # Por lo tanto, no es posible usar Array[Array[String]].

    # ARRAYS VACÍOS MULTIDIMENSIONALES

    var array_vacio_multi: Array[Array] = []

    # Añadir arrays vacíos al array multidimensional
    array_vacio_multi.append([])
    array_vacio_multi.append([])

    print("El array vacío multidimensional tiene %d elementos." %
          array_vacio_multi.size())

    # SABER SI EL ARRAY CONTIENE UN ELEMENTO ESPECÍFICO

    var contiene_alba: bool = nombres.has("Alba")

    print("¿El valor 'Alba' está en el Array 'nombres'? " + str(contiene_alba))

    # OBTENER EL MÍNIMO Y MÁXIMO DE UN ARRAY

    var numeros: Array[int] = [5, 3, 8, 2, 6]
    var minimo: int = numeros.min()
    var maximo: int = numeros.max()

    print("El número mínimo es: %d." % minimo)
    print("El número máximo es: %d." % maximo)

    # COPIAR UN ARRAY

    var array_original: Array[int] = [1, 2, 3]

    # Copia superficial
    var array_copiado: Array[int] = array_original.duplicate()

    # Copia profunda (para Arrays anidados)
    var multi_copiado: Array[Array] = array_multidimensional.duplicate(true)

    print("Array original: ", array_original)
    print("Array copiado: ", array_copiado)
    print("Array multidimensional copiado: ", multi_copiado)

    # CONCATENAR ARRAYS

    var array1: Array[int] = [1, 2, 3]
    var array2: Array[int] = [4, 5, 6]
    var concatenado: Array[int] = array1 + array2
    print("Array concatenado: ", concatenado)

    # COMPROBAR SI DOS ARRAYS SON IGUALES

    var array_a: Array[int] = [1, 2, 3]
    var array_b: Array[int] = [1, 2, 3]
    print("Los Arrays son iguales: %s" % str(array_a == array_b))

    # MÁS FUNCIONALIDADES DE ARRAY EN GDSCRIPT

    var array_ejemplo: Array[int] = [3, 1, 4, 1, 4, 9, 2]
    print("Array de ejemplo para ver más funcionalidades: ", array_ejemplo)

    # CONTAR EL NÚMERO DE VECES QUE UN ELEMENTO ESTÁ EN EL ARRAY

    var contador_unos: int = array_ejemplo.count(1)
    print("El entero 1 aparece %d veces" % contador_unos)

    # BUSCAR UN ELEMENTO Y DEVOLVER EL ÍNDICE CON SU POSICIÓN

    # Devuelve el índice de la primera aparición de un elemento en un Array
    var indice_cuatro: int = array_ejemplo.find(4)
    print("El primer entero 4 está en el índice %d" % indice_cuatro)
    # Si el elemento no se encuentra en la búsqueda, devuelve -1.

    # CAMBIAR EL TAMAÑO DEL ARRAY

    # Si el nuevo tamaño es menor que el actual, se truncan los elementos al
    # final. Si es mayor, se añaden elementos nulos (o valores por defecto).
    array_ejemplo.resize(5)
    print("Después de redimensionar: ", array_ejemplo)

    # MEZCLAR TODOS LOS ELEMENTOS DEL ARRAY EN UN ORDEN ALEATORIO

    array_ejemplo.shuffle()
    print("Después de mezclar aleatoriamente: ", array_ejemplo)
