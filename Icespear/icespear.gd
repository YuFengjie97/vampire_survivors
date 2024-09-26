extends Area2D
class_name IceSpear

var level = 1
var hp = 2
var damage = 5
var speed = 70
var attack_size = 1.0

var target = Vector2.ZERO
var direction = Vector2.ZERO

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var crush_sprite_2d: Sprite2D = $CrushSprite2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	#animated_sprite_2d.visible = true
	#crush_sprite_2d.visible = false
	match level:
		1:
			hp = 1
			damage = 5
			speed = 200
			attack_size = 1.0
	direction = global_position.direction_to(target).normalized()
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
		animation_player.play('crush')


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
