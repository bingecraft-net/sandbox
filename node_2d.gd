@tool
extends Node2D

var iterations = 0
var x = 0
var y = 0
var iso = 0.
var direction = Vector2.RIGHT

var left = 0
var right = 0
var top = 0
var bottom = 0

@export var noise = FastNoiseLite.new()

@export_tool_button("Regenerate", "Callable") var regenerate_action = regenerate


func regenerate():
	while iterations < 1_000_000:
		if iterations > 10 and x == 0 and y == 0:
			print("done after %d iterations" % iterations)
			print("bb: %d %d %d %d" % [right, bottom, left, top])
			break

		var value = noise.get_noise_2d(x, y)
		var contains = value <= iso
		var atlas_coords = Vector2i(0, 0) if contains else Vector2i(3, 0)
		$TileMapLayer.set_cell(Vector2i(x, y), 0, atlas_coords)
		
		var angle = PI / 2 if contains else - PI / 2
		direction = Vector2i(
			direction.x * cos(angle) - direction.y * sin(angle),
			direction.x * sin(angle) + direction.y * cos(angle),
		)
		var atlas_coords_direction = Vector2i(0, 1)
		if direction.y > 0.5:
			atlas_coords_direction = Vector2i(1, 1)
		elif direction.x < -0.5:
			atlas_coords_direction = Vector2i(2, 1)
		elif direction.y < -0.5:
			atlas_coords_direction = Vector2i(3, 1)
		$TileMapLayer_Direction.set_cell(Vector2i(x, y), 0, atlas_coords_direction)
		
		right = max(right, x)
		bottom = max(bottom, y)
		left = min(left, x)
		top = min(top, y)
				
		x = x + direction.x
		y = y + direction.y
		iterations += 1

@export_tool_button("Clear", "Callable") var clear_action = clear

func clear():
	print("clearing")

	iterations = 0
	x = 0
	y = 0
	iso = noise.get_noise_2d(x, y)
	direction = Vector2.RIGHT

	$TileMapLayer.clear()
	$TileMapLayer_Direction.clear()
