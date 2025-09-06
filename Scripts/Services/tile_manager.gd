class_name TileManager
extends Node2D

@export var ground_layer : TileMapLayer # navigatable terrain

@export var wall_layer : TileMapLayer		# defines bounds and solid tiles
@export var high_ground_layer : TileMapLayer

@export var spawn_layer : TileMapLayer
@export var exit_layer : TileMapLayer #defines where to exit per level
#var exit_position : Vector2i

var spawn_positions : Array[Vector2i] 
var exit_positions : Array[Vector2i] 

var astar : AStarGrid2D = AStarGrid2D.new()
var cell_size : Vector2 = Vector2(32,32)


func _ready() -> void:
	# initial bound setup
	#var rect = ground_layer.get_used_rect()
	#astar.region = rect
	astar.cell_size = cell_size
	astar.offset = astar.cell_size / 2
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	#astar.update()
	"""

	# setup solid tiles from walls
	var wall_tiles : Array[Vector2i] = wall_layer.get_used_cells_by_id()
	for pos : Vector2i in wall_tiles: 
		astar.set_point_solid(pos - rect.position)

	# setup solid tiles from high ground_layer
	var high_ground_tiles : Array[Vector2i] = high_ground_layer.get_used_cells_by_id()
	for pos : Vector2i in high_ground_tiles: 
		astar.set_point_solid(pos - rect.position)

	# setup exit tile
	var end_tiles : Array[Vector2i] = exit.get_used_cells_by_id()
	for pos : Vector2i in end_tiles: #should only have 1
		exit_position = pos
	Events.emit_signal("room_generated")
	"""
	generate_room(ground_layer, spawn_layer, exit_layer, [wall_layer, high_ground_layer])

func generate_room(ground : TileMapLayer, spawn : TileMapLayer, exit : TileMapLayer, \
	solid : Array[TileMapLayer] ):
	# generate an empty navigatable area
	astar.region = ground.get_used_rect()
	astar.update()

	# populate region with solid tiles
	for tile_map : TileMapLayer in solid:
		var tiles : Array[Vector2i] = tile_map.get_used_cells()
		for pos : Vector2i in tiles:
			astar.set_point_solid(pos, true)

	# populate list of exit positions for other game objects to optionally use
	exit_positions.clear()
	var exit_tiles : Array[Vector2i] = exit.get_used_cells()
	for pos : Vector2i in exit_tiles:
		if not astar.is_point_solid(pos):
			exit_positions.append(pos)

	spawn_positions.clear()
	var spawn_tiles : Array[Vector2i] = spawn.get_used_cells()
	for pos : Vector2i in spawn_tiles:
		if not astar.is_point_solid(pos):
			spawn_positions.append(pos)

	Events.emit_signal("room_generated")

func generate_waypoints(start_pos : Vector2i, exit_pos : Vector2i):
	var start_id = start_pos - ground_layer.get_used_rect().position
	var path : PackedVector2Array = astar.get_point_path(start_id, exit_pos)
	return path

# used to find alternate path
# TODO : implement temporary solid tiles
"""
func update_waypoints(local_pos : Vector2):
	var local_to_id = ground_layer.local_to_map(local_pos)
	var path : PackedVector2Array = astar.get_point_path(local_to_id, exit_position)
	return path
"""
