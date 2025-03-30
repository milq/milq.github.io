# Tutorial de Navegación 3D en Godot con proyección ortogonal

En este tutorial aprenderás a configurar un sistema básico de navegación 3D utilizando `NavigationRegion3D` y `NavigationAgent3D`. Aprenderás a crear mallas de navegación y mover personajes de forma inteligente en entornos tridimensionales.

La navegación en 3D permite a los personajes moverse evitando obstáculos en entornos complejos. Godot ofrece un sistema robusto con:
- `NavigationRegion3D`: Define áreas navegables
- `NavigationMesh`: Genera superficies transitables
- `NavigationAgent3D`: Calcula rutas y controla el movimiento

## Paso 1: Configura la escena principal

1. Abre Godot y crea un nuevo proyecto. Asegúrate de configurar el _Renderer_ como `Forward+` en la configuración del proyecto.
2. Crea un nodo _Node3D_ seleccionando _3D Scene_ como nodo raíz de la escena principal.
3. Renombra el nodo raíz como _MainScene_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `main_scene.tscn`.
4. En _Project → Project Settings → General → Display → Window_ establece _Viewport Width_ en `1280` y _Viewport Height_ en `720`.
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
5. Selecciona el nodo `MeshInstance3D` y, en el Inspector, crea un nuevo `BoxMesh` en el campo _Mesh_ como tipo de malla.
6. Selecciona dicha malla de tipo `PlaneMesh` y establece un tamaño de 20 m en el eje `x`, 0.5 m en el eje `y` y 20 m en el eje `z`.
7. Selecciona el nodo `NavigationRegion3D` y pulsa en el botón `Bake Navmesh` que está en la barra superior:

![Bake Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step2.png)

8. Ahora verás una malla de navegación semitransparente que flota a cierta distancia por encima del `PlaneMesh`:

![Baked Navmesh](https://docs.godotengine.org/en/stable/_images/nav_3d_min_setup_step3.png)

## Paso 3: Configura la cámara 3D para proyección ortogonal y posiciónala

1. Selecciona el nodo `Camera3D` en el _Scene Tree_.
2. En el Inspector, cambia la propiedad `Projection` de `Perspective` a `Orthogonal`.  
3. Ajusta el valor de `Size` a `20` para definir el área que capturará la cámara y abarcar todo el plano.
4. Luego, abajo, en la sección `Transform` de `Node3D`, posiciona la cámara en `x = 10`, `y = 10` y `z = 10`.
5. A continuación, justo debajo, rota la cámara `x = -30°`, `y = 45°` y `z = 0°`.
6. Ejecuta el proyecto y comprueba que la cámara muestra el plano con una proyección ortogonal o en perspectiva isómetrica:

![Cámara 3D ortogonal](tutorial_navegacion_3d_ortogonal.png "Cámara 3D ortogonal")

## Paso 4: Configurar y mover el personaje

1. Añade un nodo `CharacterBody3D` como nodo hijo de _MainScene_.
2. Luego, añade a `CharacterBody3D` los siguientes nodos como hijos:
    - Un nodo `MeshInstance3D` con una nueva malla de cápsula (`CapsuleMesh`)
        * Para darle un color, en _Surface Material Override_ de `MeshInstance3D` del _Inspector_, crea un nuevo `StandardMaterial3D`.
        * Dentro del material, ajusta el valor del `Albedo` a un tono azulado.
    - Un nodo `CollisionShape3D` con una forma (_shape_) de cápsula (`CapsuleShape3D`) que se ajuste a la malla creada anteriormente.
3. Selecciona el nodo `CharacterBody3D` y muévelo verticalmente en el eje `y` para que se sitúe encima del plano.
4. A continuación, agrega un nodo `NavigationAgent3D` como hijo de `CharacterBody3D`.
5. Selecciona el nodo `NavigationAgent3D` y, en el Inspector, ajusta el valor de `Path Height Offset` en `Pathfinding` a `-0.51` m.
6. Por último, adjunta este [_script_](https://github.com/milq/milq.github.io/blob/master/cursos/godot/scripts/player_mouse_agent.gd) al nodo `CharacterBody3D`.

## Paso 5: Ejecución del proyecto

1. En la barra de menú, dirígete a la sección `Debug` y activa la opción `Visible Navigation`. Esto hará que puedas ver las mallas de navegación durante la ejecución del juego. A continuación, selecciona el nodo `NavigationAgent3D` en el árbol de nodos. En el Inspector, dentro del apartado `NavigationAgent3D`, busca la sección `Debug` y activa la depuración cambiando el valor de `Enabled` a `On`. Esto te permitirá visualizar la ruta que sigue el agente en el editor mientras se mueve a través de la malla de navegación.
2. Ejecuta el proyecto, haz clic en una posición del plano y verifica cómo el `CharacterBody3D` se desplaza hacia el punto seleccionado.
