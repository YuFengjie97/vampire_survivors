extends CharacterBody2D

@export var move_speed = 1500

@onready var player = get_tree().get_first_node_in_group('player') as Player

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed * delta
	move_and_slide()
