extends Node2D

@export var noise = FastNoiseLite.new()
@export var grid_size = 64

@onready var cells: Node2D = $Cells

var cell_fab = load("res://scenes/cell.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(-1, 1):
		for y in range(-1, 1):
			var cell = cell_fab.instantiate()
			cell.noise = noise
			cell.grid_size = grid_size
			cell.offset = Vector2i(x, y) * grid_size
			cell.position = Vector2i(x, y) * grid_size * 16
			cells.add_child(cell)
