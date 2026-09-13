extends Node2D


@export var grid_size: int = 64
@export var noise: FastNoiseLite = FastNoiseLite.new()

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $RichTextLabel

var grid: Array[Array] = []
var next_grid: Array[Array] = []

func _ready() -> void:
	for x in range(grid_size):
		grid.push_back([])
		next_grid.push_back([])
		for y in range(grid_size):
			var value = Cell.new()
			var sample = noise.get_noise_2d(x, y)
			value.energy_density = 4 * clamp(sample, 0, 1)
			grid[x].push_back(value)
			next_grid[x].push_back(Cell.new())


func _on_timer_timeout() -> void:
	tick()

func tick():
	var total = 0.
	var total_energy = 0.
	for x in range(grid_size):
		for y in range(grid_size):
			var current_value: Cell = grid[x][y]
			var e = current_value.energy_density
			var m = current_value.mass_density
			
			var e_laplacian = 0.

			for dx in range(-1, 2):
				for dy in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor_x = (x + dx + grid_size) % grid_size
					var neighbor_y = (y + dy + grid_size) % grid_size
					var neighbor_value = grid[neighbor_x][neighbor_y]
					e_laplacian += (neighbor_value.energy_density - e) / 4.
			
			e += e_laplacian * timer.wait_time
			
			# smooth condensation (energy → matter)
			var condensation_rate = smoothstep(0.0, 1.0, (e - 0.65) / 0.2)
			var condense_amount = condensation_rate * timer.wait_time
			if e >= condense_amount:
				e -= condense_amount
				m += condense_amount
			else:
				m += e
				e = 0
			
			# smooth melting (matter → energy)
			var melting_rate = smoothstep(0.0, 1.0, (m - 0.75) / 0.2)
			var melt_amount = melting_rate * timer.wait_time
			if m >= melt_amount:
				e += melt_amount
				m -= melt_amount
			else:
				e += m
				m = 0
			
			var next_value: Cell = next_grid[x][y]
			next_value.energy_density = e
			next_value.mass_density = m
			
			total += e + m
			total_energy += e

			var coords = Vector2i(x, y)
			var atlas_coords = next_value.classify()
			tile_map_layer.set_cell(coords, 0, atlas_coords)

	var	old_grid = grid
	grid = next_grid
	next_grid = old_grid
	
	label.text = "%.0f[%.2f, %.2f]" % [total, total_energy, total - total_energy]


class Cell:
	var energy_density: float = 0.0
	var mass_density: float = 0.0
	
	func classify() -> Vector2i:
		var e = energy_density
		var m = mass_density
		return Vector2i(
			0 if e <= 0 else 1 if e <= .65 else 2 if e <= .75 else 3 ,
			0 if m <= 0 else 1 if m <= 0.75 else 2,
		)
