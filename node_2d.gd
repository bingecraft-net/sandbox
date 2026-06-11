@tool
extends Node2D

var iterations = 0
var x = 0
var y = 0
var iso = 0.
var direction

@export var noise = FastNoiseLite.new()

@export var step_size = 1_000_000

@export_tool_button("Step", "Callable") var step_action = step

func step():
	for k in range(step_size):
		if iterations > 0 and x == 0 and y == 0:
			print("done after %d iterations" % iterations)
			return
		step_one()
	print("not done after %d iterations" % iterations)

@export_tool_button("Step One", "Callable") var step_one_action = step_one

var directions = [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]

func step_one():
	var tile_size = $TileMapLayer.tile_set.tile_size
	var index = 0
	var values = [
		noise.get_noise_2d(x * tile_size.x, y * tile_size.y),
		noise.get_noise_2d((x + 1) * tile_size.x, y * tile_size.y),
		noise.get_noise_2d((x + 1) * tile_size.x, (y + 1) * tile_size.y),
		noise.get_noise_2d(x * tile_size.x, (y + 1) * tile_size.y),
	]
	if values[0] <= iso:
		index += 1
	if values[1] <= iso:
		index += 2
	if values[2] <= iso:
		index += 4
	if values[3] <= iso:
		index += 8
	$TileMapLayer.set_cell(Vector2i(x, y), 0, Vector2i(index % 4, index / 4))
	
	if direction == 0:
		if index & 3 == 1:
			direction = (4 + direction - 1) % 4
		elif index & 12 == 4:
			direction = (direction + 1) % 4
	elif direction == 1:
		if index & 6 == 2:
			direction = (4 + direction - 1) % 4
		elif index & 9 == 8:
			direction = (direction + 1) % 4
	elif direction == 2:
		if index & 12 == 4:
			direction = (4 + direction - 1) % 4
		elif index & 3 == 1:
			direction = (direction + 1) % 4
	elif direction == 3:
		if index & 9 == 8:
			direction = (4 + direction - 1) % 4
		elif index & 6 == 2:
			direction = (direction + 1) % 4
	
	#if direction != Vector2i.DOWN and (index & 1 > 0) != (index & 2 > 0):
	#	direction = Vector2i.UP
	#elif direction != Vector2i.LEFT and (index & 2 > 0) != (index & 4 > 0):
	#	direction = Vector2i.RIGHT
	#elif direction != Vector2i.UP and (index & 4 > 0) != (index & 8 > 0):
	#	direction = Vector2i.DOWN
	#elif direction != Vector2i.RIGHT and (index & 8 > 0) != (index & 1 > 0):
	#	direction = Vector2i.LEFT
	
	x = x + directions[direction].x
	y = y + directions[direction].y
	iterations += 1

@export_tool_button("Clear", "Callable") var clear_action = clear

func clear():
	iterations = 0
	x = 0
	y = 0
	iso = noise.get_noise_2d(0, 0)
	direction = 0

	$TileMapLayer.clear()
	
	print("cleared")
