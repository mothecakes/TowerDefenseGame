class_name TileManager
extends Node2D

@export var ground : TileMapLayer # navigatable terrain

@export var wall : TileMapLayer		# defines bounds and solid tiles
@export var high_ground : TileMapLayer

@export var end : TileMapLayer #defines where to end per level
var end_position : Vector2i

var astar : AStarGrid2D = AStarGrid2D.new()
var cell_size : float = 32


func _ready() -> void:
	# initial bound setup
	var rect = ground.get_used_rect()
	astar.size = rect.size
	astar.region = rect
	astar.cell_size = Vector2(cell_size, cell_size)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

	# setup solid tiles from walls
	var wall_tiles : Array[Vector2i] = wall.get_used_cells_by_id()
	print(wall_tiles)
	for pos : Vector2i in wall_tiles: 
		astar.set_point_solid(pos - rect.position)

	# setup solid tiles from high ground
	var high_ground_tiles : Array[Vector2i] = high_ground.get_used_cells_by_id()
	print(high_ground_tiles)
	for pos : Vector2i in high_ground_tiles: 
		astar.set_point_solid(pos - rect.position)

	# setup end tile
	var end_tiles : Array[Vector2i] = end.get_used_cells_by_id()
	print("end: ", end_tiles)
	for pos : Vector2i in end_tiles: #should only have 1
		end_position = pos

func generate_waypoints(start_pos : Vector2i):
	var start_id = start_pos - ground.get_used_rect().position
	print(astar.get_id_path(start_id,end_position))
	var path := astar.get_id_path(start_id, end_position)
	return path

# used to find alternate path
# TODO : implement temporary solid tiles
func update_waypoints(local_pos : Vector2):
	var local_to_id = ground.local_to_map(local_pos)
	var path : PackedVector2Array = astar.get_point_path(local_to_id, end_position)
	return path
