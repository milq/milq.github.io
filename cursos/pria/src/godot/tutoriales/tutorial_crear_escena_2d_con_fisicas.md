# Tutorial de físicas 2D en Godot con varias escenas y `Autoload`

En este tutorial aprenderás a trabajar con físicas 2D en Godot creando un proyecto donde Niblo recogerá manzanas para ganar puntos. Aprenderás a utilizar `CharacterBody2D` para el movimiento del personaje, `RigidBody2D` para las manzanas y a manejar escenas y el patrón Singleton con Autoload. Sigue los pasos cuidadosamente para completar el proyecto.

## Paso 1: Configuración del proyecto

1. Abre Godot y crea un _Nuevo Proyecto_. Asigna un nombre al proyecto y elige una carpeta donde guardarlo.
2. Haz clic en *Scene* y selecciona *New Scene*.
3. Añade un nodo *Node2D* como nodo raíz.
4. Renombra el nodo raíz como _MainScene_ y guarda la escena, seleccionando *Scene → Save Scene*, como `main_scene.tscn`.
5. Cambia el tamaño de la ventana del proyecto a 1280 x 720. Ve a *Project → Project Settings → General → Display → Window* y establece _Viewport Width_ en 1280 y _Viewport Height_ en 720.
6. Cambia el fondo del proyecto al color negro en *Project → Project Settings → General → Rendering → Environment*.

## Paso 2: Configuración de la fuente para los Label

1. Descarga y descomprime la fuente [Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P).
2. Arrastra el archivo `.ttf` de la fuente descargada a la carpeta de recursos (`res://`) en *FileSystem*.
3. En `main_scene.tscn`, añade un nodo de tipo *Label* como hijo de _MainScene_ y renómbralo como _Titulo_.
4. En el Inspector, establece el texto del `Label` como `TUTORIAL DE FÍSICAS 2D, ESCENAS Y AUTOLOAD`.
5. Selecciona el nodo _Titulo_ y arrastra el archivo `.ttf` a _&lt;empty&gt;_ en la propiedad *Control → Theme Overrides → Fonts → Font*.
6. Aumenta el tamaño de la fuente a 26 px en *Control → Theme Overrides → Fonts → Font Size*.
7. Posiciona el `Titulo` en el centro superior de la pantalla.
8. Añade otro nodo de tipo *Label* y renómbralo como _Controles_.
9. Establece el texto del nodo _Controles_ como:

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

10. Asigna la misma fuente al nodo _Controles_ repitiendo el punto 5 y ponle un tamaño de 22 px.
11. Posiciona el nodo _Controles_ en la parte inferior de la escena y centrado.

## Paso 3: Creación del Game Manager como Autoload (Singleton)

1. Crea un nuevo _script_ en la carpeta `res://` en _FileSystem_ y nómbralo `game_manager.gd`.
2. En el _script_, agrega el siguiente código:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

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

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

3. Ve a *Project → Project Settings → Globals → AutoLoad*.
4. A la derecha del campo _Path_ aparece un botón con un icono de una carpeta.
5. Pulsa dicho botón, selecciona el _script_ `game_manager.gd` y comprueba que la ruta del campo _Path_ es `res://game_manager.gd`.
6. A continuación, comprueba que en _Node Name_ aparece `GameManager` y si es así, pulsa en el botón _Add_.
7. Esto permitirá añadir el _script_ de `GameManager` como Autoload, es decir, que el _script_ esté disponible en todas las escenas como un Singleton.

## Paso 4: Creación del personaje Niblo con movimiento de plataformas

1. Crea una nueva escena y con un nodo *CharacterBody2D* como nodo raíz.
2. Renombra el nodo raíz como _Niblo_ y guarda la escena como `niblo.tscn`.
3. Descarga el _sprite_ de Niblo desde [este enlace](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png) y colócalo en la carpeta de recursos (`res://`).
4. Añade un nodo hijo *Sprite2D* al nodo _Niblo_ y asigna el _sprite_ descargado como textura.
5. Añade un nodo hijo *CollisionShape2D* al nodo _Niblo_. En el Inspector, asigna una forma adecuada como *RectangleShape2D* o *CircleShape2D* y ajusta su tamaño para que coincida con el _sprite_.
6. Selecciona el nodo _Niblo_ y añade un _script_ haciendo clic en *Attach Script*.
7. En el _script_, que extiende de `CharacterBody2D`, cambia el código existente por este otro:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

```gdscript
extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

func _physics_process(delta: float) -> void:

    if not is_on_floor():
        velocity += get_gravity() * delta

    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var direction: float = Input.get_axis("ui_left", "ui_right")

    if direction != 0:
        velocity.x = direction * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)

    move_and_slide()
```

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

8. Verifica las acciones de entrada en *Project → Project Settings → Input Map*. Activa el interruptor _Show Built-in Actions_ y verifica que las acciones `ui_left`, `ui_right` y `ui_accept` tienen asignadas las teclas correspondientes (flechas izquierda y derecha para moverse y la barra espaciadora para saltar).

## Paso 5: Creación de las manzanas como RigidBody2D con rebote

1. Crea una nueva escena y añade un nodo *RigidBody2D* como nodo raíz.
2. Renombra el nodo raíz como _Manzana_ y guarda la escena como `manzana.tscn`.
3. Descarga el _sprite_ de la manzana desde [este enlace](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/manzana.png) y colócalo en la carpeta de recursos.
4. Añade un nodo hijo *Sprite2D* al nodo _Manzana_ y asigna el _sprite_ descargado como textura.
5. Añade un nodo hijo *CollisionShape2D* al nodo _Manzana_ y asigna una forma adecuada como *CircleShape2D*.
6. Ajusta el tamaño de la *CollisionShape2D* para que coincida con el _sprite_ de la manzana.
7. Selecciona el nodo _Manzana_ y en el Inspector, crea un *New PhysicsMaterial* en la propiedad *Physics Material*. Dentro de *Physics Material*, configura el parámetro *Bounce* a `0.5` para que las manzanas reboten al caer.
8. Añade el siguiente _script_ al nodo `Manzana`:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

   ```gdscript
extends RigidBody2D

func _ready():
    if GameManager.nivel_actual == 2:
        apply_impulse(Vector2.ZERO, Vector2(-500, 0))

func _on_body_entered(body):
    if body.name == "Niblo":
        GameManager.manzanas_recogidas += 1
        queue_free()
   ```

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

## Paso 6: Creación del nivel 1

1. Crea una nueva escena con un nodo *Node2D* como nodo raíz, renómbralo como `Nivel1` y guárdala como `nivel_1.tscn`.
2. Añade un nodo de tipo *StaticBody2D* como hijo del nodo _Nivel1_ y renómbralo como `Suelo`.
3. Añade un nodo de tipo *ColorRect* como hijo del nodo `Suelo`.
4. Selecciona el nodo *ColorRect* y en el inspector ve a _Control → Layout → Transform_ y cambia los valores de _Size_ a 1280 px en _x_ y 40 px _en _y_ y en _Position_ 0 px en el eje _x_ y 680 px en el eje _y_.
4. En el Inspector, cambia la propiedad de color de ColorRect a `111111` (gris muy oscuro).
3. Añade un nodo de tipo *CollisionShape2D* como hijo del nodo `Suelo`. 
4. En el Inspector, asigna una forma *RectangleShape2D* al `CollisionShape2D` anterior y ajusta su tamaño para que cubra el nodo *ColorRect*.
3. Instancia a Niblo en la escena haciendo clic derecho en _Nivel1_, seleccionando *Instance Child Scene* y eligiendo `niblo.tscn`.
4. Situa a Niblo en la parte inferior izquierda, justo encima del suelo.
5. Instancia cinco manzanas (`manzana.tscn`) y colócalas juntas en la parte superior derecha de la escena.
6. Añade un nodo *Label*, renómbralo como _Puntos_ para mostrar los puntos y colócalo en la esquina superior izquierda.
7. Asigna la fuente al *Label* siguiendo los pasos del **Paso 2** y ponle un tamaño adecuado.
8. Agrega un _script_ a _Puntos_ con el siguiente código para actualizar los puntos:

<!-- Comentario en HTML de inicio para que no se produzcan saltos en los ítems de la lista -->

```gdscript
extends Label

func _process(delta):
    text = "Puntos: " + str(GameManager.manzanas_recogidas)
```

<!-- Comentario en HTML de fin para que no se produzcan saltos en los ítems de la lista -->

## Paso 7: Creación del nivel 2

1. Crea una nueva escena con un nodo *Node2D* como nodo raíz, renómbralo como `Nivel2` y guárdala como `nivel_2.tscn`.
2. Crea un suelo como en el **Paso 6**.
4. Instancia a Niblo en la escena, posicionando a Niblo en la parte inferior izquierda.
5. Instancia varias manzanas esta vez en el lado derecho de la escena.
6. Añade un *Label* para mostrar los puntos, siguiendo los mismos pasos que en el nivel 1.

## Paso 8: Prueba y experimentación

1. Ejecuta `main_scene.tscn` para comenzar desde el menú principal.
2. Presiona la tecla *N* para avanzar al primer nivel y prueba que Niblo pueda moverse y saltar para recoger las manzanas.
3. Verifica que las manzanas reboten al caer y que desaparezcan al colisionar con Niblo, incrementando el contador de `manzanas_recogidas` en `GameManager`.
4. Avanza al segundo nivel presionando *N* nuevamente y observa el comportamiento de las manzanas siendo lanzadas desde la derecha.
5. Experimenta ajustando la fuerza con la que se lanzan las manzanas, la posición inicial de Niblo y otros parámetros para familiarizarte con las físicas 2D en Godot.
