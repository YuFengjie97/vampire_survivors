extends Enemy

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group('player') as Player
#@onready var player = get_node('/root/World/Player') as Player

@onready var audio_hit: AudioStreamPlayer2D = $AudioHit

@export var move_speed = 2500
var health = 10
var knockback = Vector2.ZERO
var knockback_recory = 30

var explosion_scene = preload("res://Explosion/explosion.tscn")


func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed * delta
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recory)
	velocity += knockback * delta
	move_and_slide()
	
	if direction.x > 0.1:
		animated_sprite_2d.flip_h = true
	if direction.x < -0.1:
		animated_sprite_2d.flip_h = false


func _on_hurt_box_hurt(damage: Variant, direction, knockback_force) -> void:
	health -= damage
	audio_hit.play()
	knockback = direction * knockback_force


func _on_audio_hit_finished() -> void:
	if health <= 0:
		var expolision = explosion_scene.instantiate()
		expolision.global_position = global_position
		get_parent().add_child(expolision)
		queue_free()
