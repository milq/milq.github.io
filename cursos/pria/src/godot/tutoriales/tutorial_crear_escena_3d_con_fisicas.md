# Tutorial para crear una escena 3D con físicas en Godot

En este tutorial aprenderás a crear una escena 3D básica en Godot, que incluirá un plano, una cámara, luz y tres cuerpos rígidos (_RigidBody3D_): un cubo, una esfera y un cilindro. Podrás experimentar con diferentes propiedades físicas para entender el comportamiento de las físicas en Godot.

## Paso 1: Configura la escena principal

1. Abre Godot y crea un nuevo proyecto. Asegúrate de configurar el _Renderer_ como `Forward+` en la configuración del proyecto.
2. Haz clic en _Scene_ y selecciona _New Scene_.
3. Crea un nodo _Node3D_ seleccionando _3D Scene_ como nodo raíz de la escena principal.
4. Renombra el nodo raíz como _MainScene_ y guarda la escena seleccionando _Scene → Save Scene_. Nómbrala como `main_scene.tscn`.
5. Recuerda los [controles de navegación del _viewport_][T01] para orbitar y desplazarte por la escena 3D.
6. Agrega un nodo _Camera3D_ como hijo de _MainScene_ para poder visualizar la escena.
7. Añade a la escena 3D un [sol][T02] (_Add Sun to Scene_) y luego un [entorno][T03] (_Add Environment to Scene_).
8. Haz clic en _Play Scene_ para verificar que la cámara muestra un horizonte donde el cielo azul claro se separa del suelo marrón.

## Paso 2: Crea el plano base

1. Agrega un nodo _StaticBody3D_ como hijo de _MainScene_ y renómbralo como _Plano_.
2. Añade un nodo hijo _MeshInstance3D_ al nodo _Plano_.
3. Selecciona el nodo _MeshInstance3D_ y en el _Inspector_, cambia su propiedad _Mesh_ a _PlaneMesh_.
4. Selecciona la propiedad _PlaneMesh_ en el _Inspector_ y ajusta el tamaño a 10 x 10 metros.
5. Añade un nodo hijo _CollisionShape3D_ al nodo _Plano_.
6. Selecciona el nodo _CollisionShape3D_ y asigna un _Shape_ de tipo _BoxShape3D_ en el _Inspector_.
7. Selecciona _BoxShape3D_ y ajusta las dimensiones para que cubra completamente el plano con _x_ a 10 metros, _y_ a _0.01_ metros y _z_ a 10 metros.
8. Selecciona el nodo _Camera3D_ y ajusta su propiedad _Transform → Position_ para que la posición en _y_ sea 2 metros y en _z_ sea 8 metros. Ajusta la rotación si es necesario para que enfoque el plano.
9. Haz clic en _Play Scene_ para confirmar que el plano aparece correctamente en la escena.

## Paso 3: Crea un cubo con físicas

1. Agrega un nodo _RigidBody3D_ como hijo de _MainScene_ y renómbralo como _Cubo_.
2. Añade un nodo hijo _MeshInstance3D_ al nodo _Cubo_ y asígnale un _BoxMesh_ como su _Mesh_.
3. Selecciona el nodo _Cubo_ y en _Transform → Position_ colócalo a una altura (_y_) de 5 metros y rótalo (_Transform → Rotation_) 30 grados en el eje _x_, eje _y_ y eje _z_.
4. Agrega un nodo _CollisionShape3D_ como hijo de _Cubo_.
5. Selecciona el nodo _CollisionShape3D_ y asigna un _Shape_ de tipo _BoxShape3D_ en el _Inspector_.
6. Asimismo, comprueba que su _Shape_ (líneas azules) se ajusta al _Mesh_ del _MeshInstance3D_.
7. Haz clic en _Run Project_ (F5) para confirmar que el cubo cae al plano.

## Paso 4: Crea una esfera con físicas

1. Agrega un nodo _RigidBody3D_ como hijo de _MainScene_ y renómbralo como _Esfera_.
2. Añade un nodo hijo _MeshInstance3D_ al nodo _Esfera_ y asígnale un _SphereMesh_ como su _Mesh_.
3. Selecciona el nodo _Esfera_ y en _Transform → Position_ colócalo a una altura de 5 metros en el eje _y_ y a 3 metros en el eje _x_.
4. Agrega un nodo _CollisionShape3D_ como hijo de _Esfera_.
5. Selecciona el nodo _CollisionShape3D_ y asigna una forma _SphereShape3D_ en el _Inspector_.
6. Asegúrate de que las líneas de colisión del _Shape_ (color azul) coincidan correctamente con la malla de la esfera.
7. Crea un nuevo _PhysicsMaterial_ haciendo clic en el icono de flecha junto a la propiedad _PhysicsMaterial_. Selecciona _New PhysicsMaterial_ y configúralo en el _Inspector_. Cambia la propiedad _Bounce_ de este material a 0.5.
8. Haz clic en _Run Project_ (F5) para verificar que la esfera cae correctamente y rebota según la configuración del material.
9. Ajusta la posición de la esfera para que esté encima del cubo. Configura _Transform → Position_ en 7 metros en el eje _y_ y 0 metros en el eje _x_.
10. Haz clic en _Run Project_ (F5) nuevamente para confirmar que la esfera interactúa correctamente con el cubo.

## Paso 5: Crea un cilindro con físicas

1. Agrega un nodo _RigidBody3D_ como hijo de _MainScene_ y renómbralo como _Cilindro_.
2. Añade un nodo hijo _MeshInstance3D_ al nodo _Cilindro_ y asígnale un _CylinderMesh_ como su _Mesh_.
3. Selecciona el nodo _Cilindro_ y en _Transform → Position_ colócalo a una altura de 5 metros en el eje _y_ y a -3 metros en el eje _x_. Además, rota el cilindro 35 grados en los ejes _x_, _y_ y _z_ usando la propiedad _Transform → Rotation_ para comprobar su comportamiento.
4. Agrega un nodo _CollisionShape3D_ como hijo de _Cilindro_.
5. Selecciona el nodo _CollisionShape3D_ y asigna una forma _CylinderShape3D_ o _CapsuleShape3D_ en el _Inspector_.
6. Asegúrate de que las líneas de colisión del _Shape_ (color azul) coincidan correctamente con la geometría del cilindro.
7. Crea un nuevo _PhysicsMaterial_ haciendo clic en el icono de flecha junto a la propiedad _PhysicsMaterial_. Selecciona _New PhysicsMaterial_ y configúralo en el _Inspector_. Cambia la propiedad _Bounce_ de este material a 1.
8. Haz clic en _Run Project_ (F5) para verificar que el cilindro cae correctamente y rebota según la configuración del material.
9. Ajusta la posición del cilindro para que esté encima de la esfera. Configura _Transform → Position_ en 10 metros en el eje _y_ y 0 metros en el eje _x_.
10. Haz clic en _Run Project_ (F5) nuevamente para confirmar que el cilindro interactúa correctamente con la esfera y el plano.

## Paso 6: Experimenta con las herramientas de transformación

1. Selecciona el nodo _Cubo_, _Esfera_ o _Cilindro_ y usa la tecla **W** para mover el objeto en los ejes X, Y o Z.
2. Usa la tecla **E** para rotar los objetos en los ejes X, Y o Z y observa cómo afecta su orientación.
3. Usa la tecla **R** para escalar los objetos en los ejes X, Y o Z, cambiando sus dimensiones.

## Paso 6: Experimenta con las herramientas de transformación

1. Usa la tecla **Q** para seleccionar el nodo _Cubo_, _Esfera_ o _Cilindro_ y aplicar transformaciones.
2. Recuerda que también puedes seleccionar los nodos desde el panel del _Scene Tree_ para facilitar la navegación.
3. Usa la tecla **W** para mover los nodos 3D en los ejes X, Y o Z.
4. Usa la tecla **E** para rotar los nodos 3D en los ejes X, Y o Z y observa cómo afecta su orientación.
5. Usa la tecla **R** para escalar los nodos 3D en los ejes X, Y o Z, cambiando sus dimensiones.

## Paso 7: Experimenta con las propiedades de _RigidBody3D_

1. Selecciona el nodo _Cubo_ y asígnale un _PhysicsMaterial_. Haz clic en el icono de flecha junto a la propiedad _PhysicsMaterial_ en el _Inspector_, selecciona _New PhysicsMaterial_ y configúralo.
2. Modifica las propiedades _Mass_ y _Gravity Scale_ de los nodos _Cubo_, _Esfera_ y _Cilindro_ para observar cómo afectan al peso y a la interacción con la gravedad.
3. En el _PhysicsMaterial_, experimenta con las propiedades _Friction_, _Rough_, _Bounce_ y _Absorbent_, y observa cómo influyen en la interacción de los objetos con el plano y entre ellos.
4. Prueba modificar otras propiedades avanzadas como:
   - _Mass Distribution_ para ajustar cómo se distribuye el peso del objeto.
   - _Deactivation_ para controlar si los objetos pueden "dormirse" cuando están en reposo.
   - _Solver_ para cambiar cómo se resuelven las colisiones.
   - _Linear_, _Angular_ y _Constant Forces_ para aplicar fuerzas específicas que afectan al movimiento y rotación de los objetos.
5. Observa los cambios en el comportamiento de los nodos al modificar cada una de estas propiedades.

## Paso 8: Prueba y ajusta

1. Haz clic en _Play Scene_ para ejecutar la escena.
2. Observa cómo los objetos interactúan con el plano y entre sí.
3. Ajusta las posiciones, propiedades físicas y transformaciones para experimentar con diferentes escenarios y comportamientos.

[T01]: https://github.com/milq/milq.github.io/blob/master/cursos/godot/tutorials/3d_viewport_navigation_controls.md
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_sun_to_scene.png
[T03]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/godot/images/add_environment_to_scene.png
