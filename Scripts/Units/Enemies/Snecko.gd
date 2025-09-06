extends CharacterBody2D

@export var tile_manager : TileManager
@export var ground : TileMapLayer

@export var min_distance : float = 0.05
@export var speed : float = 5.0

# waypoints
var waypoints : PackedVector2Array
var waypoint_index : int = 0
var spawn_positions : Array[Vector2i]
var exit_positions : Array[Vector2i]

# movement related vars
var grid_position : Vector2i # grid position instead of pixel position
var exit_position : Vector2i
var move_direction : Vector2i
var destination_reached : bool = false

func _ready() -> void:
	#grid_position = ground.local_to_map(position)
	await Events.room_generated 
	exit_positions =  tile_manager.exit_positions.duplicate()
	spawn_positions = tile_manager.spawn_positions.duplicate()
	if spawn_positions.size() != 0:
		grid_position = spawn_positions.pick_random()
		position = ground.map_to_local(grid_position)
	else:
		print("no valid spawn position")
		return
	if exit_positions.size() != 0:
		exit_position = exit_positions.pick_random()
	else:
		print("no valid exit position")
		return

	waypoints = tile_manager.generate_waypoints(grid_position, exit_positions[0]).duplicate()

func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if not destination_reached:
		var direction : Vector2 = (waypoints[waypoint_index] - position).normalized()
		print("waypoint: ", waypoints[waypoint_index])
		print("position: ", position)
		velocity = direction * speed 

		check_waypoint_reached()
	move_and_slide()

# update position and waypoint index if close enough to waypoint
func check_waypoint_reached():
	if _is_near_waypoint():
		var waypoint = waypoints[waypoint_index]
		grid_position = ground.local_to_map(waypoint)

		waypoint_index += 1
		if waypoint_index >= waypoints.size():
			destination_reached = true

# checking if position is near waypoint
func _is_near_waypoint():
	var waypoint = waypoints[waypoint_index]
	if position.distance_to(waypoint) <= min_distance:
		return true
	return false
