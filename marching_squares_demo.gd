extends Node2D

var fnl = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fnl.frequency = 2
	var labels = Node2D.new()
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_color(Color(1, 0, 0))
	
	var size = 64
	var sizef: float = size
	var scale = 1024 / size
	var threshold = 0
	for i in range(size * size):
		var x0 = i % size
		var x1 = x0 + 1
		var y0 = i / size
		var y1 = y0 + 1
		var x0y0v = Sample(x0 / sizef, y0 / sizef)
		var x1y0v = Sample(x1 / sizef, y0 / sizef)
		var x0y1v = Sample(x0 / sizef, y1 / sizef)
		var x1y1v = Sample(x1 / sizef, y1 / sizef)
		var key = 0
		if x0y1v >= threshold:
			key = key + 1
		if x1y1v >= threshold:
			key = key + 2
		if x1y0v >= threshold:
			key = key + 4
		if x0y0v >= threshold:
			key = key + 8
	
		
		
		for tri in lookup[key]:
			for index in tri:
				var position = Vector2(x0, y0) + positions[index]
				st.add_vertex(Vector3(position.x, position.y, 0))
		
	var mesh = MeshInstance2D.new()
	mesh.scale = Vector2.ONE * scale
	mesh.mesh = st.commit()
	add_child(mesh)
	add_child(labels)
		
func Sample(x: float, y: float) -> float:
	#var distance = sqrt(pow(x - 0.5, 2) + pow(y - 0.5, 2))
	#return max(0, 1 - distance)
	print(fnl.get_noise_2d(x, y))
	return fnl.get_noise_2d(x, y)
	
var positions = [
	Vector2(0, 1),
	Vector2(0.5, 1),
	Vector2(1, 1),
	Vector2(1, 0.5),
	Vector2(1, 0),
	Vector2(0.5, 0),
	Vector2(0, 0),
	Vector2(0, 0.5)
]

var lookup = [
	[],
	[
		[0, 1, 7]
	],
	[
		[2, 1, 3]
	],
	[
		[0, 2, 7],
		[2, 7, 3]
	],
	[
		[4, 3, 5]
	],
	[
		[0, 1, 7],
		[4, 3, 5],
	],
	[
		[2, 1, 4],
		[4, 1, 5],
	],
	[
		[0, 2, 7],
		[2, 7, 5],
		[4, 2, 5],
	],
	[
		[6, 5, 7],
	],
	[
		[6, 5, 0],
		[0, 5, 1],
	],
	[
		[6, 5, 7],
		[2, 1, 3],
	],
	[
		[6, 5, 0],
		[0, 5, 3],
		[2, 0, 3],
	],
	[
		[6, 4, 7],
		[4, 3, 7],
	],
	[
		[0, 1, 6],
		[6, 3, 1],
		[4, 3, 6],
	],
	[
		[6, 4, 7],
		[4, 1, 7],
		[2, 1, 4],
	],
	[
		[0, 4, 2],
		[6, 4, 0],
	]
]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
