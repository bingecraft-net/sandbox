extends Node2D

var cell_size = 16
var chunk_size = 16
var render_size = 3
var chunks = {}


var noise = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var p = $Ship.position / cell_size / chunk_size
	for index in range(render_size * render_size):
		var key = Vector2i(
			floor(p.x) + index % render_size - render_size / 2,
			floor(p.y) + index / render_size - render_size / 2,
		)
		load_chunk(key)

func load_chunk(key: Vector2i) -> void:
	if key not in chunks:
		for index in range(chunk_size * chunk_size):
			var offset = Vector2i(index % chunk_size, index / chunk_size)
			var coords = chunk_size * key + offset
			var name = "Hydrogen2" if noise.get_noise_2d(coords.x, coords.y) > 0 else "Helium4"
			var atlas_coords = $TileMapLayer.atlas_coords.get(name)  
			$TileMapLayer.set_cell(coords, 0, atlas_coords)
		chunks[key] = 0
