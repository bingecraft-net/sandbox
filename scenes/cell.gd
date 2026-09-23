extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64
@export var offset: Vector2i = Vector2i.ZERO

@onready var map: TileMapLayer = $TileMapLayer

var elapsed = 0
var tick = 0
var mass = Array()
var mode = true
var unit = 1
var max_density = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(grid_size):
		mass.push_back([])
		for y in range(grid_size):
			mass[x].push_back(0 if randf() < 0.5 else 8)

func _process(delta: float) -> void:
	elapsed += delta

	for x in range(grid_size):
		for y in range(grid_size):
			var magnitude = 0.
			if mode:
				magnitude = mass[x][y]
			else:
				magnitude = sample(x + offset.x, y + offset.y, elapsed)
			map.set_cell(Vector2i(x, y), 0, floor(magnitude) * Vector2i.RIGHT)


func sample(x: float, y: float, elapsed: float) -> float:
	var a = noise.get_noise_3d(x + offset.x, y + offset.y, elapsed)
	var fx = atan(a * 12)
	var gx = 1 - cos(fx)
	return 16 * gx

func _on_node_2d_character_on_mode_change() -> void:
	mode = not mode

func _on_timer_timeout() -> void:
	for x in range(tick % 2, grid_size, 2):
		for y in range(tick % 2, grid_size, 2):
			var a_mass = mass[x][y]
			var b_mass = mass[(x + 1) % grid_size][y]
			var c_mass = mass[(x + 1) % grid_size][(y + 1) % grid_size]
			var d_mass = mass[x][(y + 1) % grid_size]
			var a_height = sample(x + offset.x, y + offset.y, elapsed)
			var b_height = sample(offset.x + (x + 1) % grid_size, y + offset.y, elapsed)
			var c_height = sample(offset.x + (x + 1) % grid_size, offset.y + (y + 1) % grid_size, elapsed)
			var d_height = sample(x + offset.x, offset.y + (y + 1) % grid_size, elapsed)

			if b_mass >= unit and (b_height + b_mass - unit) > (c_height + c_mass):
				b_mass -= unit
				c_mass += unit
			if c_mass >= unit and (c_height + c_mass - unit) > (d_height + d_mass):
				c_mass -= unit
				d_mass += unit
			if d_mass >= unit and (d_height + d_mass - unit) > (a_height + a_mass):
				d_mass -= unit
				a_mass += unit
			if a_mass >= unit and (a_height + a_mass - unit) > (b_height + b_mass):
				a_mass -= unit
				b_mass += unit
			
			mass[x][y] = a_mass
			mass[(x + 1) % grid_size][y] = b_mass
			mass[(x + 1) % grid_size][(y + 1) % grid_size] = c_mass
			mass[x][(y + 1) % grid_size] = d_mass
	tick += 1
	
