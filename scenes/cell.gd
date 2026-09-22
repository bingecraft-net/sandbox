extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64
@export var offset: Vector2i = Vector2i.ZERO

@onready var map: TileMapLayer = $TileMapLayer

var elapsed = 0
var mass = Array()
var mode = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(grid_size):
		mass.push_back([])
		for y in range(grid_size):
			mass[x].push_back(0 if randf() < 0.5 else 1)

func _process(delta: float) -> void:
	elapsed += delta

	for x in range(grid_size):
		for y in range(grid_size):
			var magnitude = 0.
			if mode:
				magnitude = 15 * mass[x][y]
			else:
				magnitude = 16 * sample(x + offset.x, y + offset.y, elapsed)
			map.set_cell(Vector2i(x, y), 0, floor(magnitude) * Vector2i.RIGHT)


func sample(x: float, y: float, elapsed: float) -> float:
	var a = noise.get_noise_3d(x + offset.x, y + offset.y, elapsed)
	var fx = atan(a * 24)
	var gx = cos(fx)
	return gx

func _on_node_2d_character_on_mode_change() -> void:
	mode = not mode
