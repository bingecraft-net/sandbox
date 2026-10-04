extends Node3D

@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var grid_map: GridMap = $GridMap

var length = 0
var cursor = Vector2.ZERO
var direction = 0
var directions = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]
var orientations = [0, 16, 10, 22]

func _ready() -> void:
	while length == 0 or cursor != Vector2.ZERO:
		var v0 = noise.get_noise_2dv(cursor + Vector2.LEFT  / 2 + Vector2.UP / 2) >= 0
		var v1 = noise.get_noise_2dv(cursor + Vector2.RIGHT / 2 + Vector2.UP / 2) >= 0
		var v2 = noise.get_noise_2dv(cursor + Vector2.RIGHT / 2 + Vector2.DOWN / 2) >= 0
		var v3 = noise.get_noise_2dv(cursor + Vector2.LEFT  / 2 + Vector2.DOWN / 2) >= 0

		if v0 == v1 and v1 == v2 and v2 == v3:
			push_error("Isoline does not intersect cell at position %s" % cursor)
			return

		if direction == 0:
			direction = 1 if v0 != v1 else 0 if v1 != v2 else 3
		elif direction == 1:
			direction = 2 if v0 != v3 else 1 if v0 != v1 else 0
		elif direction == 2:
			direction = 3 if v2 != v3 else 2 if v0 != v3 else 1
		elif direction == 3:
			direction = 0 if v1 != v2 else 3 if v2 != v3 else 2

		grid_map.set_cell_item(Vector3i(cursor.x, 0, cursor.y), 0, orientations[direction])

		length += 1
		cursor += directions[direction]

		if length > 1000:
			push_error("Isoline is too long, aborting")
			return
