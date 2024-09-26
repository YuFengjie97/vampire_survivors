extends Area2D
class_name IceSpear

var level = 1
var hp = 2
var damage = 5
var speed = 70
var attack_size = 1.0

var target = Vector2.ZERO
var direction = Vector2.ZERO

@onready var audio_create: AudioStreamPlayer2D = $AudioCreate
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	match level:
		1:
			hp = 2
			damage = 5
			speed = 200
			attack_size = 1.0
	direction = global_position.direction_to(target).normalized()
	rotation = direction.angle() + deg_to_rad(135)
	audio_create.play()
	var tween = create_tween()
	tween.tween_property(sprite_2d, 'scale', Vector2(1., 1.) * attack_size, 1.).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
