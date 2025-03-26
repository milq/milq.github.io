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

1. **Selecciona la cámara**  
   En el _Scene Tree_, haz clic en tu nodo `Camera3D`. Asegúrate de que tenga marcada la casilla _Current_ en el _Inspector_, de modo que sea la cámara activa en la escena.

2. **Cambia la proyección a Ortogonal**  
   En el _Inspector_, en la sección **Camera**, busca el parámetro _Projection_ y cámbialo de `Perspective` a `Orthogonal`. Esto hará que los objetos se vean sin la deformación propia de la perspectiva.

3. **Ajusta el tamaño de la proyección (Size)**  
   - A continuación, configura la propiedad **Size** (abajo de _Projection_).  
   - Un valor de `20` o `25` suele ser adecuado para abarcar un plano de 20 x 20 metros, pero puedes modificarlo según tu preferencia.  
   - Cuanto mayor sea el _Size_, mayor área abarcará la cámara en la vista.

4. **Posiciona la cámara sobre el plano**  
   - En el _Inspector_, bajo la sección **Transform**, ajusta manualmente los valores de _Translation_ para colocar la cámara por encima del plano de navegación.  
   - Por ejemplo, si quieres una vista completamente superior, puedes usar:  
     - **Translation**: `x = 0`, `y = 15`, `z = 0` (subiendo la cámara lo suficiente para ver todo el plano).  
     - **Rotation**: `x = -90°`, `y = 0°`, `z = 0°` (para apuntar directamente hacia abajo).

5. **Crea una vista isométrica opcional**  
   - Si prefieres una vista isométrica (ligeramente inclinada para ver mejor la escena 3D), ajusta la rotación en el eje `x` a aproximadamente `-45°` o `-60°`.  
   - Ajusta la posición en `y` y en `z` para centrar tu plano y asegurarte de que se vea por completo.

6. **Prueba tu configuración**  
   - Haz clic en _Play Scene_ para comprobar la vista en tiempo de ejecución.  
   - Verás que la malla de navegación y cualquier objeto en la escena se mostrarán sin distorsión de perspectiva.

7. **Ajustes finales**  
   - Si no ves todo el plano o deseas mostrar más o menos área, regresa al _Inspector_ y ajusta la propiedad **Size** hasta lograr el encuadre deseado.  
   - Recuerda que, al ser ortogonal, la escala de los objetos no cambiará por la distancia a la cámara; solo el valor de _Size_ afectará cuánto espacio se ve en pantalla.

Con estos pasos, tu `Camera3D` quedará configurada en proyección ortogonal. Ahora podrás desplazar y rotar la cámara según necesites para visualizar todo tu entorno sin distorsión, lo cual es especialmente útil en escenas que requieran una vista estratégica o de tipo _top-down_.
