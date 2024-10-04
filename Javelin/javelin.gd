extends Area2D
class_name Javelin

signal remove_from_hit_once

@onready var attack_delay_timer: Timer = $AttackDelayTimer
@onready var player = get_node('/root/World/Player') as Player
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var javelin_normal = preload("res://Textures/Items/Weapons/javelin_3_new.png")
var javelin_attack = preload("res://Textures/Items/Weapons/javelin_3_new_attack.png")

var level = 1
var hp = 9999
var damage = 5
var speed = 400.
var direction = Vector2.ZERO
var attack_size = 1.0
var knockback_force = 0
var target_num_max = 3
var attack_delay = 3

var target = player
var target_array: Array[Enemy] = []
var spawn_distance = 100

# 插值变量
var lerp_speed = 4

enum STATE { READY, FLY }
var state: STATE = STATE.READY


func _ready():
	attack_delay_timer.wait_time = attack_delay
	# 围绕player随机位置生成
	var spawn_angle = randf_range(0, PI * 2)
	var spawn_pos = player.position + Vector2.from_angle(spawn_angle) * spawn_distance
	position = spawn_pos
	match level:
		1:
			damage = 20
			speed = 500
			attack_size = 1.0
			knockback_force = 0
	state_ready_enter()


func _physics_process(delta: float) -> void:
	#在ready时，围绕player旋转
	if state == STATE.READY:
		state_ready_update(delta)
		
	if state == STATE.FLY:
		state_fly_update(delta)
	
	#标枪的朝向
	var direction_angle = position.direction_to(target.position).angle()
	rotation = lerpf(rotation, direction_angle, 10 * delta)


func remove_target_from_array(tar):
	if target_array.has(tar):
		target_array.erase(tar)
	
	# 攻击目标途中，目标死亡
	if tar == target:
		state_fly_enter()



func update_target_array(detect_enemy_num):
	var count = 0
	while count < min(target_num_max, detect_enemy_num):
		var enemy = player.get_random_enemy() as Enemy
		if enemy != null:
			# 将目标添加进target_array
			if not target_array.has(enemy):
				var enemy_hurt_box = enemy.get_node('HurtBox') as HurtBox
				target_array.append(enemy)
				count += 1
				
				# enemy被击中时，移除target
				if not enemy_hurt_box.hurt.is_connected(hit_enemy):
					enemy_hurt_box.hurt.connect(hit_enemy)
			
			# enemy死亡时，移除target
			if not enemy.death.is_connected(remove_target_from_array):
				enemy.death.connect(remove_target_from_array)


func hit_enemy(enemy, _weapon):
	# 击中目标敌人时，移除目标敌人，并更新target
	remove_target_from_array(enemy)
	if enemy == target:
		state_fly_enter()


var angle = 0
var angle_inc = 0
func state_ready_enter():
	state = STATE.READY
	sprite_2d.texture = javelin_normal
	collision_shape_2d.call_deferred('set', 'disabled', true)
	target = player
	attack_delay_timer.start()
	remove_from_hit_once.emit(self)
	
	angle = player.position.direction_to(position).angle()
	angle_inc = 0


func state_ready_update(_delta):
	angle_inc += deg_to_rad(1)
	position = player.position + Vector2.from_angle(angle + angle_inc) * spawn_distance


func state_fly_enter():
	state = STATE.FLY
	sprite_2d.texture = javelin_attack
	collision_shape_2d.call_deferred('set', 'disabled', false)
	#从剩余目标中选择一个目标
	if target_array.size() > 0:
		target = target_array[0]
	#全部目标攻击完毕
	else:
		target = player


func state_fly_update(delta):
	# 所有目标攻击完毕，回归ready状态
	if position.distance_to(player.position) <= spawn_distance and target_array.size() == 0:
		state_ready_enter()
	#运动
	#direction = position.direction_to(target.position)
	#position = position.lerp(target.position, delta * lerp_speed)
	direction = position.direction_to(target.position)
	position += direction * speed * delta


func _on_attack_delay_timer_timeout() -> void:
	var enemy_close_size = player.enemy_close.size()
	if enemy_close_size > 0:
		update_target_array(enemy_close_size)
		state_fly_enter()
	else:
		attack_delay_timer.start()
