extends CharacterBody2D
class_name Enemy

signal death(its_self)


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group('player') as Player
#@onready var player = get_node('/root/World/Player') as Player
@onready var audio_hit: AudioStreamPlayer2D = $AudioHit
@onready var hit_box: HitBox = %HitBox

@export var move_speed = 2500
@export var health = 10
@export var knockback = Vector2.ZERO
@export var knockback_recory = 30
@export var experience = 10
@export var damage = 2

const gem_scene = preload("res://Gem/gem.tscn")
const explosion_scene = preload("res://Explosion/explosion.tscn")

func _ready():
	hit_box.damage = damage

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


func spawn_gem():
	var gem = gem_scene.instantiate()
	gem.experience = experience
	gem.position = position
	var p = get_parent()
	p.call_deferred('add_child', gem)


func sapwn_explosion():
	var expolision = explosion_scene.instantiate()
	expolision.position = position
	get_parent().add_child(expolision)


func _on_hurt_box_hurt(_hurt_box_owner, hit_obj) -> void:
	var damage = hit_obj.damage
	var direction = hit_obj.direction
	var knockback_force = hit_obj.knockback_force
	health -= damage
	knockback = direction * knockback_force
	audio_hit.play()
	
	if health <= 0:
		sapwn_explosion()
		spawn_gem()
		
		death.emit(self)
		call_deferred('queue_free')
