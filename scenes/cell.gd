extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64
@export var offset: Vector2i = Vector2i.ZERO

@onready var map: TileMapLayer = $TileMapLayer

var elapsed = 0
var mass = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(grid_size):
		mass.push_back([])
		for y in range(grid_size):
			mass[x].push_back(randf())

func _process(delta: float) -> void:
	elapsed += delta
	for x in range(grid_size):
		for y in range(grid_size):
			var a = noise.get_noise_3d(x + offset.x, y + offset.y, elapsed)
			var fx = atan(a * 24)
			var gx = cos(fx)
			var magnitude = 16 * gx
			var atlas_coords = floor(magnitude) * Vector2i.RIGHT
			map.set_cell(Vector2i(x, y), 0, atlas_coords)
