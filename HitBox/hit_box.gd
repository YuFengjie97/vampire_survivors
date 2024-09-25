extends Area2D
class_name HitBox

@export var damage = 1

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer


func _on_timer_timeout() -> void:
	collision_shape_2d.call_deferred('set', 'disabled', false)


func temp_disabled():
	collision_shape_2d.call_deferred('set', 'disabled', true)
	timer.start()
