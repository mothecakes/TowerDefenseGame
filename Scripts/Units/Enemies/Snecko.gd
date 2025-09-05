extends CharacterBody2D

@export var speed : float = 5.0

@export var tile_manager : TileManager

@export var ground : TileMapLayer

var waypoints : Array[Vector2]
var waypoint_index : int = 0
var min_distance : float = 0.05

# supplied by spawner
# and updated once waypoint is reached
var pos : Vector2i

var move_direction : Vector2i

var move_time_max := 0.5
var move_time := 0.0

func _ready() -> void:
	pos = ground.local_to_map(position)
	var waypoints_int : Array[Vector2i] = tile_manager.generate_waypoints(pos).duplicate()
	for i in range(waypoints_int.size()):
		waypoints.append(ground.map_to_local(waypoints_int[i] as Vector2))
	print(waypoints)

func _physics_process(delta: float) -> void:
	var direction : Vector2 = (waypoints[0] - position).normalized()
	velocity = direction * speed * delta

	check_waypoint_reached()

func check_waypoint_reached():
	if _is_near_waypoint():
		var waypoint = waypoints[waypoint_index]
		pos = ground.local_to_map(waypoint)
		waypoint_index += 1
	pass

# update map position and pop from waypoint stack
func _is_near_waypoint():
	var waypoint = waypoints[waypoint_index]
	if position.x <= waypoint.x + min_distance and position.x >= waypoint.x - min_distance and \
		position.y <= waypoint.y + min_distance and position.y >= waypoint.y - min_distance:
			return true
	return false
