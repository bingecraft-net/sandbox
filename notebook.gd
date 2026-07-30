@tool
extends EditorScript


var noise = FastNoiseLite.new()

# Called when the script is executed (using File -> Run in Script Editor).
func _run() -> void:
	print("hello world")
	var root = EditorInterface.get_edited_scene_root()
	var tile_map_layer : TileMapLayer = root.get_node("TileMapLayer")
	tile_map_layer.set_cell(Vector2i(0, 0), 0, Vector2i(0, 0))
#	tile_map_layer.clear()
