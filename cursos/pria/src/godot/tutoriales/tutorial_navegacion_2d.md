# Tutorial de Navegación 2D en Godot

En este tutorial aprenderás a configurar lo mínimo necesario para que un personaje se mueva a través de una malla de navegación en 2D, utilizando `NavigationServer2D` y `NavigationAgent2D`.

## Paso 1: Configurar la región de navegación

1. Crea un nodo `Node2D` como escena principal.
2. Agrega un nodo `NavigationRegion2D` a la escena principal.
   - Selecciona el nodo `NavigationRegion2D`.
   - En el Inspector, crea un nuevo recurso `NavigationPolygon` para este nodo.

   ![Paso 1](https://docs.godotengine.org/en/stable/_images/nav_2d_min_setup_step1.png)

   - Esto te permitirá definir el área donde se podrá mover el personaje.

3. Define el área de navegación con la herramienta de dibujo de `NavigationPolygon`:
   - Usa la barra de herramientas para dibujar el polígono que represente la zona navegable.
   - Cuando termines de dibujar, haz clic en el botón `Bake NavigationPolygon` en la barra de herramientas.
   - Deja un margen suficiente entre los bordes del polígono y los objetos de colisión para que el personaje no quede atascado.

   ![Paso 2](https://docs.godotengine.org/en/stable/_images/nav_2d_min_setup_step2.png)

   > Nota:
   > El polígono de navegación determina dónde puede pararse y moverse el personaje con su centro. Si lo dibujas muy cerca de otros objetos de colisión, podrías provocar que el personaje se atasque cuando siga rutas cerca de esos límites.

## Paso 2: Configurar y mover el personaje

1. Agrega un nodo `CharacterBody2D` a la escena principal.
   - Agrega un `Sprite2D`, opcional pero recomendable, como hijo para tener una representación visual del personaje.
   - Añade una `CollisionShape2D` como hijo para definir su forma de colisión.

2. Agrega un nodo `NavigationAgent2D` como hijo del `CharacterBody2D`.
   - Este agente se encargará de calcular y seguir las rutas dentro de la región de navegación.
   - Asegúrate de colocarlo como hijo directo del `CharacterBody2D`.

   ![Paso 3](https://docs.godotengine.org/en/stable/_images/nav_2d_min_setup_step3.webp)

3. Adjunta el siguiente _script_ a tu `CharacterBody2D`:

```gdscript
extends CharacterBody2D

var movement_speed: float = 200.0
var movement_target_position: Vector2 = Vector2(60.0, 180.0)

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

func _ready():
    # Ajusta estos valores dependiendo de la velocidad del personaje
    # y de la forma de tu malla de navegación.
    navigation_agent.path_desired_distance = 4.0
    navigation_agent.target_desired_distance = 4.0

    # No esperes dentro de _ready; en su lugar, difiere la configuración.
    actor_setup.call_deferred()

func actor_setup():
    # Esperamos hasta el siguiente frame de física para que
    # NavigationServer se sincronice correctamente.
    await get_tree().physics_frame

    # Ahora que la malla de navegación está lista, establecemos el objetivo de movimiento.
    set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
    navigation_agent.target_position = movement_target

func _physics_process(delta):
    if navigation_agent.is_navigation_finished():
        return

    var current_agent_position: Vector2 = global_position
    var next_path_position: Vector2 = navigation_agent.get_next_path_position()

    velocity = current_agent_position.direction_to(next_path_position) * movement_speed
    move_and_slide()
```
   > Nota:
   > Asegúrate de ajustar los valores según tus necesidades. También, ten en cuenta que se hace un `call_deferred()` para esperar a un fotograma de física de *_physics_process* antes de configurar la ruta, ya que el `NavigationServer` necesita sincronizarse.

   > Nota:
   > Asegúrate de ajustar los valores según tus necesidades. También, ten en cuenta que se hace un `call_deferred()` para esperar a un fotograma de física de `_physics_process` antes de configurar la ruta, ya que el `NavigationServer` necesita sincronizarse.

4. Ejecuta el proyecto y comprueba cómo el `CharacterBody2D` se mueve hasta la posición `movement_target_position`.
   - Prueba a mover manualmente el nodo de `CharacterBody2D` en el editor.
   - Cambia los valores de `movement_target_position` en el _script_ para ver cómo el personaje actualiza su ruta en tiempo de ejecución.
