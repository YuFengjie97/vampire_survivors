extends CharacterBody2D
class_name Player

var move_speed = 2000
var mov = Vector2(0, 0)
var health = 100

var enemy_close: Array[Enemy] = []

#attack
var icespear_level = 1
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_reload_delay = 2.0

var icespear_scene = preload("res://Icespear/icespear.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var icespear_attack_timer: Timer = $WeaponManager/IcespearAttackTimer
@onready var icespear_reload_timer: Timer = $WeaponManager/IcespearReloadTimer

func _ready() -> void:
	attack()

func _input(_event):
	#var x_mov = Input.get_axis('left', 'right')
	#var y_mov = Input.get_axis('up', 'down')
	#mov.x = x_mov
	#mov.y = y_mov
	#mov = mov.normalized()
	var x_mov = Input.get_action_strength('right') - Input.get_action_strength('left')
	var y_mov = Input.get_action_strength('down') - Input.get_action_strength('up')
	mov.x = x_mov
	mov.y = y_mov
	mov = mov.normalized()
	if mov.length() > 0:
		animated_sprite_2d.play('walk')
	else:
		animated_sprite_2d.play('idle')
	if x_mov > 0:
		animated_sprite_2d.flip_h = true
	if x_mov < 0:
		animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	velocity = mov * move_speed * delta
	move_and_slide()


func _on_hurt_box_hurt(damage: Variant) -> void:
	health -= damage
	print(health)
	if health <= 0:
		print('player death')


func attack():
	if icespear_level > 0:
		icespear_reload_timer.start()


func get_random_enemy() -> Vector2:
	if enemy_close.size() > 0:
		return enemy_close.pick_random().position
	return Vector2.UP

func _on_icespear_reload_timer_timeout() -> void:
	icespear_ammo = icespear_baseammo
	icespear_attack_timer.start()
	


func _on_icespear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var target = get_random_enemy()
		var icespear = icespear_scene.instantiate()
		icespear.target = target
		add_child(icespear)
		icespear_ammo -= 1
		icespear_attack_timer.start()
	else:
		icespear_reload_timer.start()


func _on_detect_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		enemy_close.append(body)


func _on_detect_zone_body_exited(body: Node2D) -> void:
	enemy_close.erase(body)
