extends Node2D

var detail = 1
var noise = FastNoiseLite.new()
var iso = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_color(Color.SADDLE_BROWN)
	st.set_uv(Vector2(0, 0))
	
	var colliders = StaticBody2D.new()
	
	for index in range(detail * detail):
		var x = index % detail
		@warning_ignore("integer_division")
		var y = index / detail
		var id = 0
		
		var point
		var value
		
		point = global_position + global_scale * Vector2(x, y) / detail
		value = noise.get_noise_2d(point.x, point.y)
		if value >= iso: id += 1
		
		point = global_position + global_scale * Vector2(x + 1, y) / detail
		value = noise.get_noise_2d(point.x, point.y)
		if value >= iso: id += 2
		
		point = global_position + global_scale * Vector2(x + 1, y + 1) / detail
		value = noise.get_noise_2d(point.x, point.y)
		if value >= iso: id += 4
		
		point = global_position + global_scale * Vector2(x, y + 1) / detail
		value = noise.get_noise_2d(point.x, point.y)
		if value >= iso: id += 8
		
		var buf = []
		
		for vertex in lookup_geometry[id]:
			vertex = vertex + Vector2(x, y)
			vertex = vertex / detail
			st.add_vertex(Vector3(vertex.x, vertex.y, 0))
			
			buf.append(vertex)
			if len(buf) == 3:
				var collider = CollisionShape2D.new()
				collider.shape = ConvexPolygonShape2D.new()
				collider.shape.points = buf
				colliders.add_child(collider)
				buf.clear()

	
	var mesh = MeshInstance2D.new()
	mesh.mesh = st.commit()
	add_child(mesh)
	
	add_child(colliders)

var lookup_geometry = {
	0: [],
	1: [
		Vector2(0, 0),
		Vector2(0.5, 0),
		Vector2(0, 0.5),
	],
	2: [
		Vector2(1, 0),
		Vector2(1, 0.5),
		Vector2(0.5, 0),
	],
	3: [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 0.5),
		Vector2(1, 0),
		Vector2(1, 0.5),
		Vector2(0, 0.5),
	],
	4: [
		Vector2(1, 1),
		Vector2(0.5, 1),
		Vector2(1, 0.5),
	],
	5: [
		Vector2(0, 0),
		Vector2(0.5, 0),
		Vector2(0, 0.5),
		Vector2(1, 1),
		Vector2(0.5, 1),
		Vector2(1, 0.5),
	],
	6: [
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0.5, 0),
		Vector2(1, 1),
		Vector2(0.5, 1),
		Vector2(0.5, 0),
	],
	7: [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 0.5),
		Vector2(1, 0),
		Vector2(0.5, 1),
		Vector2(0, 0.5),
		Vector2(1, 1),
		Vector2(0.5, 1),
		Vector2(1, 0),
	],
	8: [
		Vector2(0, 1),
		Vector2(0, 0.5),
		Vector2(0.5, 1),
	],
	9: [
		Vector2(0, 1),
		Vector2(0, 0),
		Vector2(0.5, 1),
		Vector2(0, 0),
		Vector2(0.5, 0),
		Vector2(0.5, 1),
	],
	10: [
		Vector2(1, 0),
		Vector2(1, 0.5),
		Vector2(0.5, 0),
		Vector2(0, 1),
		Vector2(0, 0.5),
		Vector2(0.5, 1),
	],
	11: [
		Vector2(0, 1),
		Vector2(0, 0),
		Vector2(0.5, 1),
		Vector2(0, 0),
		Vector2(1, 0.5),
		Vector2(0.5, 1),
		Vector2(1, 0),
		Vector2(1, 0.5),
		Vector2(0, 0),
	],
	12: [
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(1, 0.5),
		Vector2(0, 1),
		Vector2(0, 0.5),
		Vector2(1, 0.5),
	],
	13: [
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(1, 0.5),
		Vector2(0, 1),
		Vector2(0.5, 0),
		Vector2(1, 0.5),
		Vector2(0, 0),
		Vector2(0.5, 0),
		Vector2(0, 1),
	],
	14: [
		Vector2(1, 0),
		Vector2(1, 1),
		Vector2(0.5, 0),
		Vector2(1, 1),
		Vector2(0, 0.5),
		Vector2(0.5, 0),
		Vector2(0, 1),
		Vector2(0, 0.5),
		Vector2(1, 1),
	],
	15: [
		Vector2(0, 0),
		Vector2(1, 0),
		Vector2(0, 1),
		Vector2(1, 1),
		Vector2(0, 1),
		Vector2(1, 0),
	],
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
