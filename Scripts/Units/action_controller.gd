class_name ActionController
extends Node
@export var character : CharacterBody2D 

@export var speed := 32

var vel_direction : Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	character.velocity = vel_direction 
	vel_direction = Vector2.ZERO
	character.move_and_slide()

func move_to(direction: Vector2):
	vel_direction = direction * speed
