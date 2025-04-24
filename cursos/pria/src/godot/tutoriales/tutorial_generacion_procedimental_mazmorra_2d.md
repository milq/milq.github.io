# Tutorial: Crea una mazmorra 2D generada por procedimientos

En este tutorial aprenderás a crear una mazmorra en 2D generada por procedimientos con diferentes salas de distintos tamaños. El jugador aparecerá en una ubicación inicial.

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
4. Haz clic en `TileSet`, dirígete al apartado _Physics Layers_ y pulsa en `Add Element` para añadir una [capa física][T02].
5. En la parte inferior de la pantalla, selecciona la pestaña `Tileset`, luego haz clic en el botón `+` y elige `Atlas`.
6. Elige `tilemap.png` y pulsa `Yes` cuando salga _The atlas's texture was modified. Would you like to automatically create tiles in the atlas?_
7. Selecciona la pestaña _Paint_ y, en la sección _Paint Properties_, elige _Physics Layer 0_.
8. Haz clic izquierdo en el _tile_ más claro del atlas (ubicado en la parte superior), que representa el muro, para asignarle colisión física.

[T01]: https://milq.github.io/cursos/pria/src/godot/tutoriales/tutorial_generacion_procedimental_mazmorra_2d.png
[T02]: https://raw.githubusercontent.com/milq/milq.github.io/refs/heads/master/cursos/pria/src/godot/tutoriales/tutorial_crear_tilemap_1.png

## Paso 3: Configurar y mover el personaje

1. Crea una escena con un nodo raíz de tipo `CharacterBody2D`, renombra el nodo a `Player` y guarda la escena como `player.tscn`.
2.  Haz que el nodo `Player` sea [Niblo](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png) añadiendo los siguientes nodos como hijos de `Player`:
    - Añade un `Sprite2D` para representar al personaje con esta [textura](https://raw.githubusercontent.com/milq/milq.github.io/master/cursos/pria/src/godot/sprites/niblo.png).
    - Añade un `CollisionShape2D` con un `RectangleShape2D` más pequeño que el _sprite_ para que pase por pasillos estrechos.
3. Selecciona el nodo `Player` y, en el Inspector, establece su escala a `0.25` en los ejes `x` e `y`.    
4. Adjunta el siguiente _script_ a Niblo:

```gdscript
extends CharacterBody2D

@export var speed: float = 150.0

func _process(delta: float) -> void:
    var horizontal: float = Input.get_axis("ui_left", "ui_right")
    var vertical: float = Input.get_axis("ui_up", "ui_down")
    var direction := Vector2(horizontal, vertical).normalized()
    velocity = direction * speed
    move_and_slide()
```

## Paso 4: Genera la mazmorra por procedimientos

1. En la escena _World_, selecciona el nodo `Dungeon` y asígnale un nuevo _script_ llamado `dungeon_generator.gd` con el siguiente código:

```gdscript
extends TileMapLayer

@export var map_width: int = 80
@export var map_height: int = 40
@export var min_number_of_rooms: int = 10
@export var max_number_of_rooms: int = 15
@export var min_room_size: int = 5
@export var max_room_size: int = 15
@export var bigger_corridor: bool = false

const SOURCE_ID: int = 0
const WALL_COORD := Vector2i(0, 0)
const FLOOR_COORD := Vector2i(0, 1)

var player_scene: PackedScene = preload("res://player.tscn")

var map_data: Array = []
var rooms: Array[Room] = []

class Room:
    var x: int
    var y: int
    var w: int
    var h: int

    func random_pos_and_size(
        map_width: int, map_height: int,
        min_room_size: int, max_room_size: int
    ) -> void:
        x = randi_range(1, map_width - max_room_size - 2)
        y = randi_range(1, map_height - max_room_size - 2)
        w = randi_range(min_room_size, max_room_size)
        h = randi_range(min_room_size, max_room_size)

    func mid() -> Vector2i:
        return Vector2i(x + w / 2, y + h / 2)

    func collides(check: Room) -> bool:
        var margin = 2
        return (
            x < check.x + check.w + margin and
            x + w + margin > check.x and
            y < check.y + check.h + margin and
            y + h + margin > check.y
        )

    func random_point_in_room() -> Vector2i:
        return Vector2i(
            randi_range(x, x + w - 1),
            randi_range(y, y + h - 1)
        )

    func _to_string() -> String:
        return "Room [x:%d, y:%d, w:%d, h:%d]" % [x, y, w, h]

func _ready() -> void:
    randomize()
    generate_dungeon_data()
    draw_map()
    spawn_player()

func initialize_map_data() -> void:
    map_data.clear()
    map_data.resize(map_width)
    for i in range(map_width):
        map_data[i] = []
        map_data[i].resize(map_height)
        map_data[i].fill(0)

func clear_data() -> void:
    initialize_map_data()
    rooms.clear()

func generate_dungeon_data() -> void:
    clear_data()
    var room_count: int = randi_range(
        min_number_of_rooms, max_number_of_rooms
    )

    for i in range(room_count):
        var new_room := Room.new()
        var attempts = 0
        var max_attempts = 100

        while attempts < max_attempts:
            new_room.random_pos_and_size(
                map_width, map_height,
                min_room_size, max_room_size
            )
            if not does_collide(new_room):
                break
            attempts += 1

        if attempts == max_attempts:
            print(
                "Warning: Could not place room %d after %d attempts." %
                [i, max_attempts]
            )
            continue

        rooms.append(new_room)
        for tile_x in range(new_room.x, new_room.x + new_room.w):
            for tile_y in range(new_room.y, new_room.y + new_room.h):
                if tile_x >= 0 and tile_x < map_width and \
                   tile_y >= 0 and tile_y < map_height:
                    map_data[tile_x][tile_y] = 1

    create_corridors()
    add_walls()

func does_collide(room: Room) -> bool:
    for existing_room in rooms:
        if room.collides(existing_room):
            return true
    return false

func create_corridors() -> void:
    if rooms.size() < 2:
        return

    for i in range(rooms.size() - 1):
        var room_a = rooms[i]
        var room_b = rooms[i + 1]
        var point_a := room_a.random_point_in_room()
        var point_b := room_b.random_point_in_room()
        connect_points(point_a, point_b)

func connect_points(point_a: Vector2i, point_b: Vector2i) -> void:
    var current_pos := point_a

    while current_pos != point_b:
        if current_pos.x != point_b.x:
            var move_dir = signi(point_b.x - current_pos.x)
            current_pos.x += move_dir
        elif current_pos.y != point_b.y:
            var move_dir = signi(point_b.y - current_pos.y)
            current_pos.y += move_dir

        if current_pos.x >= 0 and current_pos.x < map_width and \
           current_pos.y >= 0 and current_pos.y < map_height:
            map_data[current_pos.x][current_pos.y] = 1
            if bigger_corridor:
                if current_pos.x + 1 < map_width:
                    map_data[current_pos.x + 1][current_pos.y] = 1
                if current_pos.y + 1 < map_height:
                    map_data[current_pos.x][current_pos.y + 1] = 1
                if current_pos.x + 1 < map_width and \
                   current_pos.y + 1 < map_height:
                    map_data[current_pos.x + 1][current_pos.y + 1] = 1

func add_walls() -> void:
    for x in range(map_width):
        for y in range(map_height):
            if map_data[x][y] == 1:
                for check_x in range(x - 1, x + 2):
                    for check_y in range(y - 1, y + 2):
                        if check_x == x and check_y == y:
                            continue
                        if check_x >= 0 and check_x < map_width and \
                           check_y >= 0 and check_y < map_height:
                            if map_data[check_x][check_y] == 0:
                                map_data[check_x][check_y] = 2

func draw_map() -> void:
    clear()
    for x in range(map_width):
        for y in range(map_height):
            var tile_type = map_data[x][y]
            var cell_coord = Vector2i(x, y)
            if tile_type == 1:
                set_cell(cell_coord, SOURCE_ID, FLOOR_COORD)
            elif tile_type == 2:
                set_cell(cell_coord, SOURCE_ID, WALL_COORD)

func get_start_position_world() -> Vector2:
    if rooms.is_empty():
        return map_to_local(Vector2i(map_width / 2, map_height / 2))

    var start_tile_coord: Vector2i = rooms[0].mid()
    var tile_size = tile_set.tile_size
    var world_pos = map_to_local(start_tile_coord) + tile_size / 2.0
    return world_pos

func spawn_player() -> void:
    if player_scene == null:
        print("Error: Player scene not set in Dungeon node inspector.")
        return
    if rooms.is_empty():
        print("Error: No rooms generated, cannot spawn player.")
        return

    var player_instance = player_scene.instantiate()
    var world_node = get_parent()
    if world_node:
        world_node.add_child.call_deferred(player_instance)
        player_instance.global_position = get_start_position_world()
        print("Player spawned at: ", player_instance.global_position)
    else:
        print("Error: Dungeon node must be a child of the World scene.")
```

## Paso 5: Ejecución del proyecto

1. Ejecuta el proyecto desde Godot haciendo clic en el botón de *Play* (o presionando `F5`).
2. Verás que la mazmorra se genera de forma aleatoria cada vez que inicias el juego. Esto es parte del sistema de generación procedural.
3. Usa las teclas de los cursores para mover a Niblo por la mazmorra o pulsa `Esc` para salir del juego.
4. Vuelve a ejecutar el juego varias veces y observa cómo cambian la disposición de las habitaciones y los pasillos en cada generación.
5. Experimenta modificando los valores exportados en el nodo `Dungeon`, como:
   - `map_width` y `map_height` para cambiar el tamaño general de la mazmorra.
   - `min_room_size` y `max_room_size` para ajustar el tamaño de las habitaciones.
   - `min_number_of_rooms` y `max_number_of_rooms` para controlar cuántas habitaciones se generan.
   - `bigger_corridor` para hacer los pasillos más anchos.
