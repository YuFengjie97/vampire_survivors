extends Area2D
class_name IceSpear

signal remove_from_hit_once(area)

@onready var player = get_node('/root/World/Player') as Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var crush_sprite_2d: Sprite2D = $CrushSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var level = 1
var hp = 2
var damage = 5
var speed = 70
var attack_size = 1.0
var knockback_force = 5000 # 击退力量

var target = Vector2.ZERO
var direction = Vector2.ZERO # 朝向target的单位向量

func _ready() -> void:
	position = player.position
	var random_enemy = player.get_random_enemy()
	if random_enemy != null:
		target = random_enemy.position
	else:
		target = Vector2.RIGHT
	match level:
		1:
			hp = 2
			damage = 5
			speed = 100
			attack_size = 1.0
	direction = global_position.direction_to(target)
	rotation = direction.angle()
	AudioBus.play("res://Audio/SoundEffect/ice.wav", 4)
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, 'scale', Vector2(1., 1.) * attack_size, 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	if hp > 0:
		position += direction * speed * delta


func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		remove_from_hit_once.emit(self)
		animation_player.play('crush')


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	remove_from_hit_once.emit(self)
	queue_free()
