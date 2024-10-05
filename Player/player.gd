extends CharacterBody2D
class_name Player

signal level_up_chosed

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var icespear_manager: IcespearManager = $WeaponManager/IcespearManager
@onready var tornado_manager: TornadoManager = $WeaponManager/TornadoManager
@onready var javelin_manager: JavelinManager = $WeaponManager/JavelinManager
@onready var progress_bar_exp: TextureProgressBar = $UILayer/ProgressBarExp
@onready var label_level: Label = $UILayer/LabelLevel
@onready var audio_level_up: AudioStreamPlayer2D = $UILayer/LevelUpPanel/AudioLevelUp
@onready var level_up_panel: PanelContainer = $UILayer/LevelUpPanel
@onready var level_up_items_container: VBoxContainer = $UILayer/LevelUpPanel/VBoxContainer/LevelUpItemsContainer

const LEVEL_UP_OPTION_ITEM = preload("res://LevelUpOptionItem/level_up_option_item.tscn")
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
var level_up_item_max = 3

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
		progress_bar_exp.value = 100
		show_level_up_options()
		await level_up_chosed
		exp_collected -= exp_level
		level += 1
		exp_level = level * 50
		level_up()


func upgrade(upgrade_info):
	print(upgrade_info)
	hide_level_up_options()


func spawn_level_up_item():
	for child in level_up_items_container.get_children():
		child.queue_free()
	
	for i in range(level_up_item_max):
		var item = LEVEL_UP_OPTION_ITEM.instantiate()
		item.selected_upgrade.connect(upgrade)
		level_up_items_container.add_child(item)


func show_level_up_options():
	get_tree().paused = true
	audio_level_up.play()
	spawn_level_up_item()
	
	var tween = level_up_panel.create_tween()
	var view_width = get_viewport_rect().size.x
	var panel_width = level_up_panel.size.x
	tween.tween_property(level_up_panel, "position", Vector2(view_width / 2. - panel_width / 2., 30), 0.35).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func hide_level_up_options():
	level_up_chosed.emit()
	level_up_panel.position = Vector2(680, 30)
	get_tree().paused = false
	
	
