# -----------------------
# HOLA, MUNDO EN GDSCRIPT
# -----------------------
# Ejecútalo en el editor de 'scripts' de Godot con File → Run
# (Ctrl + Shift + X). El resultado sale en el panel Output.

@tool
extends EditorScript

func _run() -> void:
    print("¡Hola, mundo!")

# EXPLICACIÓN

# @tool                   Indica que este 'script' se ejecuta dentro del
#                         editor de Godot.

# extends EditorScript    Especifica que este 'script' hereda de EditorScript,
#                         la clase de los 'scripts' que se ejecutan con
#                         File → Run.

# func _run() -> void:    Define la función '_run', que es el punto de entrada
#                         cuando el 'script' se ejecuta en el editor.
#                         '-> void' indica que no devuelve ningún valor.

# print("¡Hola, mundo!")  Imprime el mensaje "¡Hola, mundo!" en el panel
#                         Output del editor.
