# Tutorial: Crea una mazmorra 2D generada por procedimientos

En este tutorial aprenderás a crear una mazmorra en 2D generada por procedimientos con diferentes salas de distintos tamaños. El jugador aparecerá en una ubicación inicial y deberá encontrar la salida, mientras evita enemigos que lo perseguirán.

## Paso 1: Configuración del proyecto

1. Abre Godot y crea un _Nuevo Proyecto_. Asigna un nombre al proyecto, como `MazmorraProcedural`, y elige una carpeta donde guardarlo.
2. Haz clic en *Scene*, selecciona *New Scene* y añade un nodo *Node2D* como nodo raíz.
3. Renombra el nodo raíz como _World_ y guarda la escena como `world.tscn` (*Scene → Save Scene*).
4. En _Project → Project Settings → General → Display → Window_ establece _Viewport Width_ en `1280` y _Viewport Height_ en `720`.
5. En _Project → Project Settings → General → Rendering → Textures establece _Default Texture Filter_ a `Nearest`.
6. Cambia el fondo del proyecto al color negro en *Project → Project Settings → General → Rendering → Environment*.

## Paso 2: Crea la base para generar la mazmorra

1. Añade un nuevo nodo hijo al nodo `World`, de tipo `TileMapLayer` y renómbralo como `Dungeon`.
2. Descarga este [_tileset_][T01], renómbralo como `atlas.png` y arrástralo a la carpeta de recursos del proyecto (`res://`).
3. Selecciona el nodo `Dungeon` y, en el Inspector, haz clic en `<empty>` del campo `TileSet` y elige *New TileSet*.
4. En la parte inferior de la pantalla, selecciona la pestaña `Tileset`, luego haz clic en el botón `+` y elige `Atlas`.
5. Elige `tilemap_packed.png` y pulsa `Yes` cuando aparezca _The atlas's texture was modified. Would you like to automatically create tiles in the atlas?_

[T01]: https://milq.github.io/cursos/pria/src/godot/tutoriales/tutorial_generacion_procedimental_mazmorra_2d.png
