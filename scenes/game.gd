extends Node3D

@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var grid_map: GridMap = $GridMap
@onready var character_body: CharacterBody3D = $Character/CharacterBody3D

var length = 0
var cursor = Vector3.ZERO
var entry_direction = Vector3.ZERO
var exit_direction = Vector3.ZERO

var exit_table = {
	1: {
		Vector3.RIGHT: Vector3.BACK,
		Vector3.FORWARD: Vector3.LEFT,
	},
	2: {
		Vector3.FORWARD: Vector3.RIGHT,
		Vector3.LEFT: Vector3.BACK,
	},
	3: {
		Vector3.RIGHT: Vector3.RIGHT,
		Vector3.LEFT: Vector3.LEFT,
	},
	4: {
		Vector3.LEFT: Vector3.FORWARD,
		Vector3.BACK: Vector3.RIGHT,
	},
	5: {
		Vector3.RIGHT: Vector3.BACK,
		Vector3.FORWARD: Vector3.LEFT,
		Vector3.LEFT: Vector3.FORWARD,
		Vector3.BACK: Vector3.RIGHT,
	},
	6: {
		Vector3.FORWARD: Vector3.FORWARD,
		Vector3.BACK: Vector3.BACK,
	},
	7: {
		Vector3.RIGHT: Vector3.FORWARD,
		Vector3.BACK: Vector3.LEFT,
	},
	8: {
		Vector3.RIGHT: Vector3.FORWARD,
		Vector3.BACK: Vector3.LEFT,
	},
	9: {
		Vector3.FORWARD: Vector3.FORWARD,
		Vector3.BACK: Vector3.BACK,
	},
	10: {
		Vector3.RIGHT: Vector3.FORWARD,
		Vector3.FORWARD: Vector3.RIGHT,
		Vector3.LEFT: Vector3.BACK,
		Vector3.BACK: Vector3.LEFT,
	},
	11: {
		Vector3.LEFT: Vector3.FORWARD,
		Vector3.BACK: Vector3.RIGHT,
	},
	12: {
		Vector3.RIGHT: Vector3.RIGHT,
		Vector3.LEFT: Vector3.LEFT,
	},
	13: {
		Vector3.FORWARD: Vector3.RIGHT,
		Vector3.LEFT: Vector3.BACK,
	},
	14: {
		Vector3.RIGHT: Vector3.BACK,
		Vector3.FORWARD: Vector3.LEFT,
	},
	21: {
		Vector3.RIGHT: Vector3.FORWARD,
		Vector3.FORWARD: Vector3.RIGHT,
		Vector3.LEFT: Vector3.BACK,
		Vector3.BACK: Vector3.LEFT,
	},
	26: {
		Vector3.RIGHT: Vector3.BACK,
		Vector3.FORWARD: Vector3.LEFT,
		Vector3.LEFT: Vector3.FORWARD,
		Vector3.BACK: Vector3.RIGHT,
	},
}


func _ready() -> void:
	advance()
	character_body.position = cursor - exit_direction + Vector3.UP * .625 + Vector3.RIGHT / 2
	character_body.look_at(cursor + exit_direction + Vector3.RIGHT / 2)
	while advance():
		pass


func advance() -> bool:
	if length != 0 and cursor == Vector3.ZERO:
		print("Isoline finished. Length: %d" % length)
		return false

	if length > 1000:
		push_error("Isoline is too long, aborting")
		return false

	if length != 0 and exit_direction == Vector3.ZERO:
		push_error("Invalid exit_direction")
		return false

	var v0 = noise.get_noise_3dv(cursor + Vector3.LEFT  / 2 + Vector3.FORWARD / 2) >= 0
	var v1 = noise.get_noise_3dv(cursor + Vector3.RIGHT / 2 + Vector3.FORWARD / 2) >= 0
	var v2 = noise.get_noise_3dv(cursor + Vector3.RIGHT / 2 + Vector3.BACK / 2) >= 0
	var v3 = noise.get_noise_3dv(cursor + Vector3.LEFT  / 2 + Vector3.BACK / 2) >= 0
	var v4 = noise.get_noise_3dv(cursor) >= 0

	if v0 == v1 and v1 == v2 and v2 == v3:
		push_error("Isoline does not intersect cell at position %s" % cursor)
		return false

	var saddle = v0 != v1 and v1 != v2 and v2 != v3

	var iso_case = (16 if v4 and saddle else 0) + (8 if v0 else 0) + (4 if v1 else 0) + (2 if v2 else 0) + (1 if v3 else 0)

	entry_direction = exit_direction
	var table = exit_table[iso_case]
	if exit_direction == Vector3.ZERO:
		exit_direction = table.keys()[0]
	exit_direction = table[exit_direction]
	entry_direction = entry_direction if entry_direction != Vector3.ZERO else exit_direction

	var item = 0
	var cross = entry_direction.cross(exit_direction)
	if cross.y < 0:
		item = 2
	elif cross.y > 0:
		item = 1
	if saddle:
		item += 2

	var _basis = Basis.looking_at(entry_direction)
	var orientation = grid_map.get_orthogonal_index_from_basis(_basis)

	grid_map.set_cell_item(cursor, item, orientation)

	length += 1

	if false:
		print({
			"length": length,
			"cursor": cursor,
			"iso_case": iso_case,
			"entry_direction": entry_direction,
			"exit_direction": exit_direction,
			"item": item,
			"orientation": orientation,
		})

	cursor += exit_direction

	return true
