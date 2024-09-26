extends Enemy

@export var move_speed = 1500
var health = 10
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group('player') as Player

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed * delta
	move_and_slide()
	
	if direction.x > 0.1:
		animated_sprite_2d.flip_h = true
	if direction.x < -0.1:
		animated_sprite_2d.flip_h = false


func _on_hurt_box_hurt(damage: Variant) -> void:
	health -= damage
	if health <= 0:
		call_deferred('queue_free')
