extends Area2D
class_name Tornado

signal remove_from_hit_once(area2d)

@onready var player = get_node('/root/World/Player') as Player


var level = 1
var hp = 9999
var damage = 5
var speed = 70
var attack_size = 1.0
var additional_size = 0.
var knockback_force = 5000

var direction = Vector2.RIGHT
var direction_angle = 0
var angle_half_range_min = 10
var angle_half_range_max = 45

func _ready():
	position = player.position
	direction = player.lastmove
	# 在player direction方向距离x生成
	position += direction * 18
	
	direction_angle = direction.angle()
	random_tween()
	
	match level:
		1:
			hp = 9999
			damage = 4
			speed = 70
			attack_size = 1.0
			knockback_force = 5000
		2:
			hp = 9999
			damage = 8
			speed = 70
			attack_size = 1.0
			knockback_force = 5000
		3:
			hp = 9999
			damage = 10
			speed = 70
			attack_size = 1.0
			knockback_force = 5000
		4:
			hp = 9999
			damage = 20
			speed = 100
			attack_size = 1.5
			knockback_force = 5000


func get_random_angle(is_less: bool) -> float:
	var angle_inc = deg_to_rad(randf_range(angle_half_range_min, angle_half_range_max))
	return (direction_angle - angle_inc) if is_less else (direction_angle + angle_inc)


func random_tween():
	var type = randi_range(0, 1) == 0
	var tween = create_tween()
	var duration = 1.2
	tween.tween_property(self, 'direction_angle', get_random_angle(type), duration)
	tween.tween_property(self, 'direction_angle', get_random_angle(!type), duration)
	tween.tween_property(self, 'direction_angle', get_random_angle(type), duration)
	tween.tween_property(self, 'direction_angle', get_random_angle(!type), duration)
	tween.tween_property(self, 'direction_angle', get_random_angle(type), duration)
	tween.tween_property(self, 'direction_angle', get_random_angle(!type), duration)


func _physics_process(delta: float) -> void:
	var direction_mov = Vector2.from_angle(direction_angle)
	position += direction_mov * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	remove_from_hit_once.emit(self)
	queue_free()
