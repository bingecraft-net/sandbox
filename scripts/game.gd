extends Node2D

@export var noise = FastNoiseLite.new()
@export var grid_size = 64

@onready var map: TileMapLayer = $TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var elapsed = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed += delta
	for x in range(grid_size):
		for y in range(grid_size):
			var value = noise.get_noise_3d(x, y, elapsed)
			var atlas_coords = classify(value)
			map.set_cell(Vector2i(x, y), 0, atlas_coords)


func classify(value: float) -> Vector2i:
	var result = clamp(0, pow(abs(value), -0.9) - 1, 15) * Vector2i.RIGHT
	return result
