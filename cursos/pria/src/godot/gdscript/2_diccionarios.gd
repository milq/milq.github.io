# ------------------------
# DICCIONARIOS EN GDSCRIPT
# ------------------------

@tool
extends EditorScript

func _run() -> void:
    # CREAR UN DICCIONARIO

    # En GDScript, un Dictionary es una colección de pares clave-valor.

    var mi_diccionario: Dictionary = {
        "nombre": "Juan",
        "edad": 30,
        "altura": 1.75
    }

    # Actualmente, no se puede crear un Dictionary con tipos explícitos
    # Por ejemplo, esto da error: var datos_persona: Dictionary[String, int]

    # ACCEDER A LOS VALORES E IMPRIMIR UN DICCIONARIO

    # Acceder a valores mediante sus claves.
    var nombre: String = mi_diccionario["nombre"]
    var edad: int = mi_diccionario["edad"]

    print("El nombre es %s y tiene %d años." % [nombre, edad])

    # Imprimir el diccionario completo.
    print("Datos del diccionario: ", mi_diccionario)

    # MODIFICAR VALORES EN UN DICCIONARIO

    mi_diccionario["edad"] = 35
    mi_diccionario["altura"] = 1.85

    print("Datos actualizados: ", mi_diccionario)

    # AÑADIR NUEVOS PARES CLAVE-VALOR

    mi_diccionario["peso"] = 82.5
    mi_diccionario["ciudad"] = "Madrid"

    print("Después de añadir nuevos datos: ", mi_diccionario)

    # ELIMINAR PARES CLAVE-VALOR DADA UNA CLAVE ESPECÍFICA

    mi_diccionario.erase("altura")

    print("Después de eliminar 'altura': ", mi_diccionario)

    # VACIAR UN DICCIONARIO

    mi_diccionario.clear()

    print("Diccionario después de 'clear': ", mi_diccionario)

    # COMPROBAR SI UNA CLAVE EXISTE EN EL DICCIONARIO

    var persona: Dictionary = {
        "nombre": "Ana",
        "edad": 25,
        "altura": 1.65
    }

    var existe_nombre: bool = "nombre" in persona
    print("¿Existe la clave 'nombre'? " + str(existe_nombre))

    # Otra alternativa es usar 'has' para comprobar si una clave existe
    var tiene_edad: bool = persona.has("edad")
    print("¿Tiene la clave 'edad'? " + str(tiene_edad))

    # Comprobar si contiene todas las claves dadas.
    var claves_a_verificar: Array[String] = ["nombre", "edad"]
    var tiene_todas: bool = persona.has_all(claves_a_verificar)
    print("¿Tiene todas las claves? " + str(tiene_todas))

    # OBTENER LAS CLAVES Y VALORES

    var claves: Array = persona.keys()
    var valores: Array = persona.values()

    print("Claves del diccionario: ", claves)
    print("Valores del diccionario: ", valores)

    # OBTENER EL TAMAÑO DEL DICCIONARIO

    var tamaño: int = persona.size()
    print("El diccionario tiene %d elementos." % tamaño)

    # COMBINAR DOS DICCIONARIOS

    var diccionario_a: Dictionary = {"a": 1, "b": 2}
    var diccionario_b: Dictionary = {"b": 3, "c": 4}
    var combinado: Dictionary = diccionario_a.duplicate()
    combinado.merge(diccionario_b, true) # En caso de claves duplicadas, se sobrescribe el valor.

    print("Diccionario combinado: ", combinado)

    # COPIAR UN DICCIONARIO

    # Copia superficial.
    var diccionario_copia: Dictionary = persona.duplicate()
    print("Copia del diccionario: ", diccionario_copia)

    # Copia profunda (para diccionarios anidados).
    var diccionario_anidado: Dictionary = {
        "animal": {"especie": "Perro", "raza": "Labrador"}
    }

    var copia_profunda: Dictionary = diccionario_anidado.duplicate(true)
    print("Copia profunda: ", copia_profunda)

    # COMPROBAR SI EL DICCIONARIO ESTÁ VACÍO

    var esta_vacio: bool = mi_diccionario.is_empty()
    print("¿El diccionario está vacío? " + str(esta_vacio))

    # USO DE 'hash'

    var hash_diccionario: int = persona.hash()
    print("Hash del diccionario: ", hash_diccionario)

    # USO DE 'operator =='

    var diccionario_x: Dictionary = {"x": 10, "y": 20}
    var diccionario_y: Dictionary = {"x": 10, "y": 20}
    var son_iguales: bool = diccionario_x == diccionario_y
    print("¿Los diccionarios son iguales? " + str(son_iguales))

    # USO DE 'operator !='

    diccionario_y["y"] = 30
    var son_diferentes: bool = diccionario_x != diccionario_y
    print("¿Los diccionarios son diferentes? " + str(son_diferentes))

    # DICCIONARIOS ANIDADOS

    var anidado = {
        "cadena": 5,
        4: [1, 2, 3],
        7: "Hola",
        "subdiccionario": {"subclave": "Valor anidado"},
    }

    print("Valor de subdiccionario: ", anidado["subdiccionario"]["subclave"])

    # DICCIONARIOS DE ARRAYS

    var diccionario_de_arrays: Dictionary = {
        "pares": [2, 4, 6, 8],
        "impares": [1, 3, 5, 7]
    }

    print("Números pares: ", diccionario_de_arrays["pares"])
    print("Números impares: ", diccionario_de_arrays["impares"])

    # Añadir un nuevo array al diccionario.
    diccionario_de_arrays["primos"] = [2, 3, 5, 7]
    print("Números primos: ", diccionario_de_arrays["primos"])

    # ARRAYS DE DICCIONARIOS

    var array_de_diccionarios: Array[Dictionary] = [
        {"nombre": "Mario", "edad": 30},
        {"nombre": "Laura", "edad": 25},
        {"nombre": "Pablo", "edad": 35}
    ]

    var nombre_primera_persona: String = array_de_diccionarios[0]["nombre"]
    print("El primer nombre es: ", nombre_primera_persona)
