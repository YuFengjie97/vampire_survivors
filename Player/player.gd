extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var icespear_manager: IcespearManager = $WeaponManager/IcespearManager
@onready var tornado_manager: TornadoManager = $WeaponManager/TornadoManager
@onready var javelin_manager: JavelinManager = $WeaponManager/JavelinManager
@onready var progress_bar_exp: TextureProgressBar = $UILayer/ProgressBarExp
@onready var label_level: Label = $UILayer/LabelLevel


var move_speed = 10000
var mov = Vector2(0, 0)
var health = 100
var enemy_close: Array[Enemy] = []
var lastmove = Vector2.UP
var level = 0:
	set(val):
		level = val
		label_level.text = 'Level ' + str(val)
var exp_collected = 0.
var exp_level = 50. # 当前级别升级需要的经验


func _ready() -> void:
	icespear_manager.attack()
	tornado_manager.attack()
	javelin_manager.attack()


func _input(_event):
	var x_mov = Input.get_axis('left', 'right')
	var y_mov = Input.get_axis('up', 'down')
	#var x_mov = Input.get_action_strength('right') - Input.get_action_strength('left')
	#var y_mov = Input.get_action_strength('down') - Input.get_action_strength('up')
	mov.x = x_mov
	mov.y = y_mov
	if mov != Vector2.ZERO:
		lastmove = mov
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


func _on_hurt_box_hurt(_hurt_box_owner, hit_obj) -> void:
	health -= hit_obj.damage
	if health <= 0:
		pass


func get_random_enemy():
	if enemy_close.size() > 0:
		return enemy_close.pick_random()
	return null


func _on_detect_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		enemy_close.append(body)


func _on_detect_zone_body_exited(body: Node2D) -> void:
	enemy_close.erase(body)


func _on_grab_zone_area_entered(area: Area2D) -> void:
	if area is Gem:
		area.target = self


func _on_collected_zone_area_entered(area: Area2D) -> void:
	if area is Gem:
		var experience = area.collected()
		exp_collected += experience
		level_up()


func level_up():
	if exp_collected < exp_level:
		progress_bar_exp.value = exp_collected / exp_level * 100.
	else:
		exp_collected -= exp_level
		level += 1
		exp_level = level * 50
		progress_bar_exp.value = 100.
		level_up()
