extends Node3D

@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var grid_map: GridMap = $GridMap

var length = 0
var cursor = Vector2.ZERO
var direction = Vector2.RIGHT

func _ready() -> void:
	while length == 0 or cursor != Vector2.ZERO:
		var v0 = noise.get_noise_2dv(cursor + Vector2.LEFT  / 2 + Vector2.UP / 2) >= 0
		var v1 = noise.get_noise_2dv(cursor + Vector2.RIGHT / 2 + Vector2.UP / 2) >= 0
		var v2 = noise.get_noise_2dv(cursor + Vector2.RIGHT / 2 + Vector2.DOWN / 2) >= 0
		var v3 = noise.get_noise_2dv(cursor + Vector2.LEFT  / 2 + Vector2.DOWN / 2) >= 0

		if v0 == v1 and v1 == v2 and v2 == v3:
			push_error("Isoline does not intersect cell at position %s" % cursor)
			return
		
		grid_map.set_cell_item(Vector3i(cursor.x, 0, cursor.y), 1, 1 + 4 * int(randf() * 2))

		if direction == Vector2.RIGHT:
			direction = Vector2.UP if v0 != v1 else Vector2.RIGHT if v1 != v2 else Vector2.DOWN
		elif direction == Vector2.UP:
			direction = Vector2.LEFT if v0 != v3 else Vector2.UP if v0 != v1 else Vector2.RIGHT
		elif direction == Vector2.LEFT:
			direction = Vector2.DOWN if v2 != v3 else Vector2.LEFT if v0 != v3 else Vector2.UP
		elif direction == Vector2.DOWN:
			direction = Vector2.RIGHT if v1 != v2 else Vector2.DOWN if v2 != v3 else Vector2.LEFT

		length += 1
		cursor += direction

		if length > 1000:
			push_error("Isoline is too long, aborting")
			return
