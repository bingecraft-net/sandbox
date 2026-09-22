extends Node2D

@export var noise: FastNoiseLite = FastNoiseLite.new()
@export var grid_size: int = 64

@onready var cell: Node2D = $Cell

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cell.noise = noise
	cell.grid_size = grid_size
	cell.offset = Vector2i.ONE * grid_size / -2
	cell.position = Vector2i.ONE * grid_size * 16 / -2
