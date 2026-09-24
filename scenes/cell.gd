extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64
@export var offset: Vector2i = Vector2i.ZERO

@onready var map: TileMapLayer = $TileMapLayer

var elapsed = 0
var mass = Array()
var mode = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(grid_size):
		mass.push_back([])
		for y in range(grid_size):
			mass[x].push_back(.8)

func _process(delta: float) -> void:
	elapsed += delta

	for x in range(grid_size):
		for y in range(grid_size):
			var magnitude = 0.
			if mode:
				magnitude = 15 * mass[x][y]
			else:
				magnitude = 16 * sample(x, y, elapsed)
			map.set_cell(Vector2i(x, y), 0, floor(magnitude) * Vector2i.RIGHT)


func sample(x: float, y: float, elapsed: float) -> float:
	var a = noise.get_noise_3d(x + offset.x, y + offset.y, elapsed)
	var fx = atan(a * 24)
	var gx = cos(fx)
	return gx

func _on_node_2d_character_on_mode_change() -> void:
	mode = not mode


var tick = 0
func _on_timer_timeout() -> void:
	tick += 1
	for x in range(tick % 2, grid_size, 2):
		for y in range(tick % 2, grid_size, 2):
			var x0 = x
			var x1 = (x + 1) % grid_size
			var y0 = y
			var y1 = (y + 1) % grid_size
			
			var m00 = mass[x0][y0]
			var m10 = mass[x1][y0]
			var m11 = mass[x1][y1]
			var m01 = mass[x0][y1]
			
			var a00 = sample(x0, y0, elapsed)
			var a10 = sample(x1, y0, elapsed)
			var a11 = sample(x1, y1, elapsed)
			var a01 = sample(x0, y1, elapsed)
			
			var mean = (m00 + m10 + m11 + m01 + a00 + a10 + a11 + a01) / 4.
			
			mass[x0][y0] += (mean - m00 - a00)
			mass[x1][y0] += (mean - m10 - a10)
			mass[x1][y1] += (mean - m11 - a11)
			mass[x0][y1] += (mean - m01 - a01)
