extends Enemy


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group('player') as Player
#@onready var player = get_node('/root/World/Player') as Player


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


func _on_hurt_box_hurt(_hurt_box_owner, hit_obj) -> void:
	var damage = hit_obj.damage
	var direction = hit_obj.direction
	var knockback_force = hit_obj.knockback_force
	health -= damage
	knockback = direction * knockback_force
	AudioBus.play("res://Audio/SoundEffect/enemy_hit.ogg", 1, -10)
	if health <= 0:
		death.emit(self)
		var expolision = explosion_scene.instantiate()
		expolision.global_position = global_position
		get_parent().add_child(expolision)
		queue_free()
