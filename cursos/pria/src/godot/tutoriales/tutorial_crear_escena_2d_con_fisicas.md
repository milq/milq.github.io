# Tutorial de físicas 2D en Godot con varias escenas y `Autoload`

En este tutorial aprenderás a trabajar con físicas 2D en Godot creando un proyecto donde Niblo recogerá manzanas para ganar puntos. Aprenderás a utilizar `CharacterBody2D` para el movimiento del personaje, `RigidBody2D` para las manzanas y a manejar escenas y el patrón Singleton con Autoload. Sigue los pasos cuidadosamente para completar el proyecto.

## Paso 1: Configuración del proyecto

1. Abre Godot y crea un _Nuevo Proyecto_. Asigna un nombre al proyecto y elige una carpeta donde guardarlo.
2. Haz clic en *Scene* y selecciona *New Scene*.
3. Añade un nodo *Node2D* como nodo raíz.
4. Renombra el nodo raíz como `MainScene` y guarda la escena seleccionando *Scene → Save Scene*. Nómbrala como `main_scene.tscn`.
5. Cambia el tamaño de la ventana del proyecto a 1280 x 720. Ve a *Project → Project Settings → General → Display → Window* y establece _Viewport Width_ en `1280` y _Viewport Height_ en `720`.
6. Cambia el fondo del proyecto al color negro en *Project → Project Settings → General → Rendering → Environment*.

## Paso 2: Configuración de la fuente para los Label

1. Descarga y descomprime la fuente [Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P).
2. Arrastra el archivo `.ttf` de la fuente descargada a la carpeta de recursos (`res://`) en *FileSystem*.
3. En `main_scene.tscn`, añade un nodo de tipo *Label* como hijo de `MainScene` y renómbralo como _Title_.
4. En el Inspector, establece el texto del `Label` como _TUTORIAL DE FÍSICAS 2D, ESCENAS Y AUTOLOAD_.
5. Selecciona el nodo _Title_ y arrastra el archivo `.ttf` a la propiedad *Control → Theme Overrides → Fonts → Font*.
6. Aumenta el tamaño de la fuente a 26 px en *Control → Theme Overrides → Fonts → Font Size*.
7. Posiciona el `Titulo` en el centro superior de la pantalla.
8. Añade otro nodo de tipo *Label* y renómbralo como _Controles_.
9. Establece el texto del _Controles_ como:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

   ```
   CONTROLES:

   Mover → Flechas izquierda/derecha

   Saltar → Barra espaciadora

   R → Reiniciar nivel

   M → Volver al menú principal

   Esc → Salir

   N → Pasar al siguiente nivel
   ```

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

10. Asigna la misma fuente a `Controles` siguiendo el paso 5 y sigue el paso 6 pero con un tamaño de 22 px.
11. Posiciona el `Controles` en una ubicación visible en la escena.

## Paso 3: Creación del personaje Niblo con movimiento de plataformas

1. Crea una nueva escena y con un nodo *CharacterBody2D* como nodo raíz.
2. Renombra el nodo raíz como `Niblo` y guarda la escena como `niblo.tscn`.
3. Descarga el _sprite_ de Niblo desde [este enlace](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png) y colócalo en la carpeta de recursos (`res://`).
4. Añade un nodo hijo *Sprite2D* al nodo `Niblo` y asigna el _sprite_ descargado como textura.
5. Añade un nodo hijo *CollisionShape2D* al nodo `Niblo`. En el Inspector, asigna una forma adecuada como *RectangleShape2D* o *CircleShape2D* y ajusta su tamaño para que coincida con el _sprite_.
6. Selecciona el nodo `Niblo` y añade un _script_ haciendo clic en *Attach Script*.
7. En el _script_, que extiende de `CharacterBody2D` agrega el siguiente código:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

```gdscript
extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:

    if not is_on_floor():
        velocity.y += get_gravity() * delta

    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction := Input.get_axis("ui_left", "ui_right")

    if direction != 0:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
```

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

8. Configura las acciones de entrada en *Project → Project Settings → Input Map*. Añade las acciones `ui_left`, `ui_right` y `ui_accept` asignando las teclas correspondientes (por ejemplo, flechas izquierda y derecha para moverse y la barra espaciadora para saltar).

## Paso 4: Creación de las manzanas como RigidBody2D con rebote

1. Crea una nueva escena y añade un nodo *RigidBody2D* como nodo raíz.
2. Renombra el nodo raíz como `Manzana` y guarda la escena como `manzana.tscn`.
3. Descarga el sprite de la manzana desde [este enlace](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/manzana.png) y colócalo en la carpeta de recursos.
4. Añade un nodo hijo *Sprite2D* al nodo `Manzana` y asigna el sprite descargado como textura.
5. Añade un nodo hijo *CollisionShape2D* al nodo `Manzana` y asigna una forma adecuada como *CircleShape2D*.
6. Ajusta el tamaño de la *CollisionShape2D* para que coincida con el sprite de la manzana.
7. Selecciona el nodo `Manzana` y en el Inspector, añade un *PhysicsMaterial* en la propiedad *Physics Material*. Configura el parámetro *Bounce* a `0.5` para que las manzanas reboten al caer.
8. Añade el siguiente script al nodo `Manzana`:

   ```gdscript
   extends RigidBody2D

   func _on_body_entered(body):
       if body.name == "Niblo":
           GameManager.manzanas_recogidas += 1
           queue_free()
   ```

9. Conecta la señal `body_entered` del nodo `Manzana` al método `_on_body_entered(body)`.

## Paso 5: Creación del Game Manager como Autoload (Singleton)

1. Crea un nuevo script en la carpeta `res://` y nómbralo `game_manager.gd`.
2. En el script, agrega el siguiente código:

   ```gdscript
   extends Node

   var manzanas_recogidas: int = 0
   var nivel_actual: int = 0

   func _unhandled_input(event: InputEvent) -> void:
       if event is InputEventKey and event.pressed:
           match event.physical_keycode:
               KEY_R:
                   get_tree().reload_current_scene()
               KEY_M:
                   get_tree().change_scene_to_file("res://main_scene.tscn")
               KEY_ESCAPE:
                   get_tree().quit()
               KEY_N:
                   if nivel_actual == 0:
                       get_tree().change_scene_to_file("res://nivel1.tscn")
                       nivel_actual = 1
                   elif nivel_actual == 1:
                       get_tree().change_scene_to_file("res://nivel2.tscn")
                       nivel_actual = 2
                   else:
                       get_tree().change_scene_to_file("res://main_scene.tscn")
                       nivel_actual = 0
   ```

   *Nota:* Hemos cambiado la tecla para pasar al siguiente nivel a `KEY_N`.

3. Ve a *Project → Project Settings → AutoLoad*, selecciona el script `game_manager.gd` y añádelo como autoload con el nombre `GameManager`. Esto permitirá que el script esté disponible en todas las escenas como un singleton.

## Paso 6: Creación del suelo como StaticBody2D

1. Crea una nueva escena y guárdala como `suelo.tscn`.
2. Añade un nodo *StaticBody2D* y renómbralo como `Suelo`.
3. Añade un nodo hijo *CollisionShape2D* al nodo `Suelo`.
4. En el Inspector, asigna una forma *RectangleShape2D* al `CollisionShape2D` y ajusta su tamaño para que cubra la parte inferior de la escena, representando el suelo donde Niblo puede pararse.

## Paso 7: Creación del nivel 1

1. Crea una nueva escena y guárdala como `nivel1.tscn`.
2. Añade un nodo *Node2D* como nodo raíz y renómbralo como `Nivel1`.
3. Instancia el suelo en la escena haciendo clic derecho en `Nivel1`, seleccionando *Instance Child Scene* y eligiendo `suelo.tscn`.
4. Instancia a Niblo en la escena y posiciónalo en la parte inferior izquierda, justo sobre el suelo.
5. Instancia cinco manzanas (`manzana.tscn`) y colócalas en la parte superior de la escena, de manera que caigan hacia Niblo.
6. Añade un nodo *Label* para mostrar los puntos y colócalo en la esquina superior izquierda.
7. Asigna la fuente y tamaño al *Label* siguiendo los pasos del **Paso 2**.
8. En el script del *Label*, agrega el siguiente código para actualizar los puntos:

   ```gdscript
   extends Label

   func _process(delta):
       text = "Puntos: " + str(GameManager.manzanas_recogidas)
   ```

## Paso 8: Creación del nivel 2

1. Crea una nueva escena y guárdala como `nivel2.tscn`.
2. Añade un nodo *Node2D* como nodo raíz y renómbralo como `Nivel2`.
3. Instancia el suelo y a Niblo en la escena, posicionando a Niblo en la parte inferior izquierda.
4. Instancia varias manzanas en el lado derecho de la escena.
5. En el script de las manzanas, agrega una fuerza inicial en el método `_ready()` para lanzarlas hacia la izquierda:

   ```gdscript
   func _ready():
       apply_impulse(Vector2.ZERO, Vector2(-500, 0))  # Ajusta la fuerza según sea necesario
   ```

6. Añade un *Label* para mostrar los puntos, siguiendo los mismos pasos que en el nivel 1.

## Paso 9: Prueba y experimentación

1. Ejecuta `main_scene.tscn` para comenzar desde el menú principal.
2. Presiona la tecla *N* para avanzar al primer nivel y prueba que Niblo pueda moverse y saltar para recoger las manzanas.
3. Verifica que las manzanas reboten al caer y que desaparezcan al colisionar con Niblo, incrementando el contador de `manzanas_recogidas` en `GameManager`.
4. Avanza al segundo nivel presionando *N* nuevamente y observa el comportamiento de las manzanas siendo lanzadas desde la derecha.
5. Experimenta ajustando la fuerza con la que se lanzan las manzanas, la posición inicial de Niblo y otros parámetros para familiarizarte con las físicas 2D en Godot.

## Conclusión

Has creado un juego sencillo en Godot que utiliza físicas 2D para simular el movimiento de un personaje y objetos en el mundo del juego. Has aprendido a usar `CharacterBody2D` para el movimiento del personaje, `RigidBody2D` para objetos físicos y a manejar escenas y el patrón Singleton con Autoload. Continúa explorando y experimentando con Godot para seguir desarrollando tus habilidades.

*Nota:* Recuerda mantener tu código y estructura de nodos organizados para facilitar su mantenimiento y comprensión. Evita utilizar listas anidadas y sigue buenas prácticas de programación.
