# Tutorial de Navegación 3D en Godot

En este tutorial aprenderás a configurar un sistema básico de navegación 3D utilizando `NavigationRegion3D` y `NavigationAgent3D`. Aprenderás a crear mallas de navegación y mover personajes de forma inteligente en entornos tridimensionales.

La navegación en 3D permite a los personajes moverse evitando obstáculos en entornos complejos. Godot ofrece un sistema robusto con:
- `NavigationRegion3D`: Define áreas navegables
- `NavigationMesh`: Genera superficies transitables
- `NavigationAgent3D`: Calcula rutas y controla el movimiento

## Paso 1: Configura la escena principal

1. Abre Godot y crea un nuevo proyecto. Asegúrate de configurar el _Renderer_ como `Forward+` en la configuración del proyecto.
2. Haz clic en _Scene_ y selecciona _New Scene_.
3. Crea un nodo _Node3D_ seleccionando _3D Scene_ como nodo raíz de la escena principal.
4. Renombra el nodo raíz como _MainScene_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `main_scene.tscn`.
5. Recuerda los [controles de navegación del _viewport_][T01] para orbitar y desplazarte por la escena 3D.
6. Agrega un nodo _Camera3D_ como hijo de _MainScene_ para poder visualizar la escena.
7. Añade a la escena 3D un [sol][T02] (_Add Sun to Scene_) y luego un [entorno][T03] (_Add Environment to Scene_).
8. Haz clic en _Play Scene_ para verificar que la cámara muestra un horizonte donde el cielo azul claro se separa del suelo marrón.

[T01]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/tutorials/3d_viewport_navigation_controls.md
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_sun_to_scene.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_environment_to_scene.png

## Paso 2: Configura la malla de navegación

1. Añade un nodo `NavigationRegion3D` como nodo hijo de _MainScene_.
2. Selecciona tu nodo `NavigationRegion3D`
3. En el Inspector, crea un nuevo `NavigationMesh` para este nodo:
   
![Navmesh Setup](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step1.png)

4. Añade un nodo `MeshInstance3D` como hijo del nodo `NavigationRegion3D`.
5. Selecciona el nodo `MeshInstance3D` y, en el Inspector, crea un nuevo `PlaneMesh` en el campo _Mesh_ como tipo de malla.
6. Selecciona dicha malla de tipo `PlaneMesh` y establece un tamaño de 10 m en el eje `x` y 10 m en el eje `y`.
7. Selecciona el nodo `NavigationRegion3D` y pulsa en el botón `Bake Navmesh` que está en la barra superior:

![Bake Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step2.png)

8. Ahora verás una malla de navegación transparente que flota a cierta distancia por encima del `PlaneMesh`:

![Baked Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step3.png)

## Paso 3: Configura el personaje

1. **Crea el personaje**:
   - Añade un `CharacterBody3D` a la escena
   - Configura componentes hijos:
     - `CollisionShape3D` con forma de cápsula
     - `MeshInstance3D` con malla cilíndrica

2. **Añade el agente de navegación**:
   - Agrega un nodo `NavigationAgent3D` como hijo
   - Configura propiedades clave:
     - `Path Max Distance`: 5.0
     - `Avoidance Enabled`: True

   ![Agent Setup](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step4.webp)

## Paso 4: Implementa un movimiento inteligente

Adjunta este _script_ al `CharacterBody3D`:

````markdown
```gdscript
extends CharacterBody3D

var velocidad_movimiento: float = 3.5
var objetivo: Vector3 = Vector3(-3.0, 0.0, 2.0)

@onready var agente_navegacion: NavigationAgent3D = $NavigationAgent3D

func _ready():
    agente_navegacion.path_desired_distance = 0.5
    agente_navegacion.target_desired_distance = 0.5
    configurar_agente.call_deferred()

func configurar_agente():
    await get_tree().physics_frame
    establecer_objetivo(objetivo)

func establecer_objetivo(nuevo_objetivo: Vector3):
    agente_navegacion.target_position = nuevo_objetivo

func _physics_process(delta):
    if agente_navegacion.is_navigation_finished():
        return
    
    var posicion_actual = global_position
    var siguiente_punto = agente_navegacion.get_next_path_position()
    
    velocity = posicion_actual.direction_to(siguiente_punto) * velocidad_movimiento
    move_and_slide()
```
````

> ⚠️ Importante: Usa `call_deferred()` para asegurar sincronización con el servidor de navegación

## Paso 5: Depuración y ejecución del Proyecto

1. **Visualización en tiempo real**:
   - Activa **Debug > Visible Navigation**
   - Verás rutas calculadas (líneas amarillas)
   - Usa `Debug > Navigation > Debug Agent Paths` para seguimiento

2. **Ajustes avanzados**:
   - Modifica `NavigationMesh` properties:
     - `Agent Height`: Altura mínima de pasajes
     - `Max Slope`: Ángulo máximo de pendientes transitables
   - Experimenta con `Avoidance Layers` para múltiples agentes

3. **Movimiento dinámico**:
   ```gdscript
   func _input(event):
       if event is InputEventMouseButton:
           var posicion_mundo = get_global_mouse_position()
           establecer_objetivo(posicion_mundo)
   ```

## Paso 6: Consideraciones finales

- **Obstáculos dinámicos**: Usa `NavigationObstacle3D` para objetos móviles
- **Actualizaciones en tiempo real**: Llama `bake()` programáticamente para mallas cambiantes
- **Optimización**: Usa múltiples `NavigationRegion3D` para escenas grandes

![Resultado Final](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step3.png)

Ahora tu personaje puede navegar complejos entornos 3D. ¡Experimenta con diferentes configuraciones y añade obstáculos para crear comportamientos más realistas!
