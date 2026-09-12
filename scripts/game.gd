extends Node2D

@export var gravity_constant: float = 0.01
@export var grid_size: int = 64
@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var grid: Array[Array] = []
var crs: CoordinateReferenceSystem = CoordinateReferenceSystem.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	crs.grid_size = grid_size
	for x in range(grid_size):
		grid.append([])
		for y in range(grid_size):
			var value = noise.get_noise_2d(x, y) + 1
			grid[x].append(value)
			var coords = crs.forward(x, y)
			var atlas_coords = classify(value)
			tile_map_layer.set_cell(coords, 0, atlas_coords)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var next_grid: Array[Array] = []
	for x in range(grid_size):
		next_grid.append([])
		for y in range(grid_size):
			var current_mass = grid[x][y]
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor_x = (x + dx + grid_size) % grid_size
					var neighbor_y = (y + dy + grid_size) % grid_size
					var neighbor_mass = grid[neighbor_x][neighbor_y]

			next_grid[x].append(current_mass)

			var coords = crs.forward(x, y)
			var atlas_coords = classify(current_mass)
			tile_map_layer.set_cell(coords, 0, atlas_coords)
	grid = next_grid

class CoordinateReferenceSystem:
	var grid_size: int
	func forward(x: float, y: float) -> Vector2i:
		return Vector2i(x, y) - Vector2i.ONE * grid_size / 2

func classify(value: float) -> Vector2i:
	var stretch = value * 4
	if stretch <= 0:
		return Vector2i.ZERO
	elif stretch > 8:
		return Vector2i.RIGHT
	return Vector2i.DOWN + Vector2i.RIGHT * int(stretch)