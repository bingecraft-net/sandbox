extends Node2D

var detail = 1
var noise = FastNoiseLite.new()
var iso = 0

var container: Node2D

var edits = {}


class ColliderTool:
	var graph = {}
	var working_tri = []
	
	
	func add_vertex(vertex: Vector2):
		working_tri.append(vertex)
		if len(working_tri) == 3:
			add_tri(working_tri)
			working_tri = []
	
	
	func add_tri(tri: Array):
		for index in range(3):
			var start = tri[index]
			var end = tri[(index + 1) % 3]
			graph[start] = graph[start] if start in graph else []
			graph[start].append(end)

	
	func commit():
		var graph_shake = {}
		for start in graph:
			for end in graph[start]:
				if start not in graph[end]:
					graph_shake[start] = graph_shake[start] if start in graph_shake else []
					graph_shake[start].append(end)
		graph = graph_shake

		var static_body = StaticBody2D.new()

		while len(graph) > 0:
			var start
			for _start in graph:
				start = _start
				break
			var contour = []
			while start != null:
				contour.append(start)
				var ends = graph.get(start)
				graph.erase(start)
				start = ends[0] if ends else null
			
			var polygon = CollisionPolygon2D.new()
			polygon.build_mode = CollisionPolygon2D.BUILD_SEGMENTS
			polygon.polygon = contour
			static_body.add_child(polygon)
		
		return static_body

func global_position_to_local_grid(_global_position: Vector2) -> Vector2i:
	return global_scale_to_local_grid(_global_position - global_position)
	
func global_scale_to_local_grid(_global_scale: Vector2) -> Vector2i:
	var unscale = _global_scale / global_scale
	var local_grid = unscale * detail
	return Vector2i(round(local_grid.x), round(local_grid.y))
	
func local_grid_to_global_position(local_grid: Vector2i) -> Vector2:
	return Vector2(local_grid.x, local_grid.y) / detail * global_scale + global_position

func get_value(x: float, y: float) -> float:
	var local_grid = global_position_to_local_grid(Vector2(x, y))
	var edit = edits.get(local_grid)
	if edit: return edit + noise.get_noise_2d(x, y)
	return noise.get_noise_2d(x, y)
	
func brush_value(xy: Vector2, radius: int, delta: float):
	if (xy - global_position - global_scale / 2).length() > global_scale.length() / 2:
		return 0 
	var count = 0
	var brush_top_left = global_position_to_local_grid(xy - Vector2.ONE * radius)
	var brush_steps = global_scale_to_local_grid(Vector2.ONE * radius * 2)
	for index in range(brush_steps.x * brush_steps.y):
		var x = index % brush_steps.y
		var y = index / brush_steps.y
		var pos = brush_top_left + Vector2i(x, y)
		if (local_grid_to_global_position(pos) - xy).length() < radius and \
			pos.x >= 0 and pos.x <= detail and \
			pos.y >= 0 and pos.y <= detail:
			edits[pos] = (edits[pos] if pos in edits else 0) + delta
			count += 1
	return count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate()

func generate() -> void:
	var last_container = container
	container = Node2D.new()
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_color(Color.SADDLE_BROWN)
	st.set_uv(Vector2(0, 0))
	
	var ct = ColliderTool.new()
	
	for index in range(detail * detail):
		var x = index % detail
		@warning_ignore("integer_division")
		var y = index / detail
		var id = 0
		
		var point
		var value
		
		point = global_position + global_scale * Vector2(x, y) / detail
		value = get_value(point.x, point.y)
		if value >= iso: id += 1
		
		point = global_position + global_scale * Vector2(x + 1, y) / detail
		value = get_value(point.x, point.y)
		if value >= iso: id += 2
		
		point = global_position + global_scale * Vector2(x + 1, y + 1) / detail
		value = get_value(point.x, point.y)
		if value >= iso: id += 4
		
		point = global_position + global_scale * Vector2(x, y + 1) / detail
		value = get_value(point.x, point.y)
		if value >= iso: id += 8
				
		for vertex in lookup_geometry[id]:
			vertex = vertex + Vector2(x, y)
			vertex = vertex / detail
			st.add_vertex(Vector3(vertex.x, vertex.y, 0))
			ct.add_vertex(vertex)
	
	var mesh = MeshInstance2D.new()
	mesh.mesh = st.commit()
	container.add_child(mesh)
	
	container.add_child(ct.commit())
	
	if last_container:
		last_container.queue_free()
	
	add_child(container)

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

func _on_mining_tool_action(pos: Vector2, radius: float, delta: float) -> void:
	if brush_value(pos, radius, delta) > 0:
		generate()
