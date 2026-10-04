extends Node3D

@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var grid_map: GridMap = $GridMap
@onready var character_body: CharacterBody3D = $Character/CharacterBody3D

var length = 0
var cursor = Vector3.ZERO
var entry_direction = -1
var exit_direction = -1
var directions = [Vector3.RIGHT, Vector3.FORWARD, Vector3.LEFT, Vector3.BACK]
var orientations = [0, 16, 10, 22]

var exit_table = {
	1:  [3, 2, -1, -1],
	2:  [-1, 0, 3, -1],
	3:  [0, -1, 2, -1],
	4:  [-1, -1, 1, 0],
	5: [3, 2, 1, 0],
	6:  [-1, 1, -1, 3],
	7:  [1, -1, -1, 2],
	8:  [1, -1, -1, 2],
	9:  [-1, 1, -1, 3],
	10: [1, 0, 3, 2],
	11: [-1, -1, 1, 0],
	12: [0, -1, 2, -1],
	13: [-1, 0, 3, -1],
	14: [3, 2, -1, -1],
	21: [1, 0, 3, 2],
	26: [3, 2, 1, 0]
}

var item_table = {
	0: [0, 1, -1, 2],
	1: [2, 0, 1, -1],
	2: [-1, 2, 0, 1],
	3: [1, -1, 2, 0],
}

func _ready() -> void:
	advance()
	character_body.position = cursor - directions[exit_direction] + Vector3.UP * 2
	character_body.look_at(cursor + directions[exit_direction])
	while advance():
		pass


func advance() -> bool:
	if length != 0 and cursor == Vector3.ZERO:
		print("Isoline finished. Length: %d" % length)
		return false

	if length > 1000:
		push_error("Isoline is too long, aborting")
		return false

	if length != 0 and exit_direction == -1:
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

	var iso_case = (8 if v0 else 0) + (4 if v1 else 0) + (2 if v2 else 0) + (1 if v3 else 0)
	var saddle = iso_case == 5 or iso_case == 10
	iso_case += 16 if v4 and saddle else 0

	entry_direction = exit_direction
	exit_direction = exit_table[iso_case][exit_direction]
	entry_direction = entry_direction if entry_direction >= 0 else exit_direction

	var item = item_table[entry_direction][exit_direction]
	item += 2 if saddle else 0

	var orientation = orientations[entry_direction]

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

	cursor += directions[exit_direction]

	return true
