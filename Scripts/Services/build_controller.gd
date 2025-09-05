extends Node

@export var ground : TileMapLayer
@export var preview : TileMapLayer


var select_mode : bool = true
var preview_tile : Vector2i

func get_snapped_pos(global_pos: Vector2) -> Vector2i:
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)

	return tile_pos

func _process(delta: float) -> void:
	var pos = get_snapped_pos(get_viewport().get_mouse_position()) 
	if select_mode:
		preview.erase_cell(preview_tile)
		preview_tile = pos
		preview.set_cell(preview_tile, 0, Vector2i(0,0))
		pass
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		ground.set_cell(pos, 0, Vector2i(0,0))

	pass
