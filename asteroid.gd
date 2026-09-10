extends Node2D


@onready var rigid_body: RigidBody2D = $RigidBody2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var atlas_names = {
	Vector2i(0, 0): "hot solar nebula gas",
	Vector2i(1, 0): "hydrogen solar gas",
	Vector2i(0, 1): "trace solar gas",
	Vector2i(1, 1): "solar dust",
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	generate_asteroid()


class Ellipse:
	var axis: Vector2i = Vector2i(0, 0)
	var center: Vector2i = Vector2i(0, 0)

	# Area = π * a * b, where a and b are semi-axes
	static func from_area(area: float, semi_major: float) -> Ellipse:
		var semi_minor: float = area / (PI * semi_major)
		var ellipse = Ellipse.new()
		ellipse.axis = Vector2i(Vector2(semi_major, semi_minor))
		return ellipse

func generate_asteroid() -> void:
	var ellipse = Ellipse.from_area(
		randf_range(1000.0, 10000.0),
		randf_range(25.0, 50.0),
	)

	# Clear existing tiles
	tile_map_layer.clear()

	# Iterate over bounding box of the ellipse
	for x in range(ellipse.center.x - ellipse.axis.x, ellipse.center.x + ellipse.axis.x + 1):
		for y in range(ellipse.center.y - ellipse.axis.y, ellipse.center.y + ellipse.axis.y + 1):
			var cell: Vector2i = Vector2i(x, y)
			# Ellipse equation: (x/a)² + (y/b)² ≤ 1
			var dx: float = float(cell.x - ellipse.center.x) / ellipse.axis.x
			var dy: float = float(cell.y - ellipse.center.y) / ellipse.axis.y
			if dx * dx + dy * dy <= 1.0:
				var atlas_coords = Vector2i(0, 0)
				tile_map_layer.set_cell(cell, 0, atlas_coords)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	tile_map_layer.position = rigid_body.position
