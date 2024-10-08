extends CharacterBody2D
class_name Player

signal upgrade_chosed
signal hp_change
signal death

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var progress_bar_exp: TextureProgressBar = $UILayer/ProgressBarExp
@onready var label_level: Label = $UILayer/LabelLevel
@onready var audio_level_up: AudioStreamPlayer2D = $UILayer/LevelUpPanel/AudioLevelUp
@onready var level_up_panel: PanelContainer = $UILayer/LevelUpPanel
@onready var level_up_items_container: VBoxContainer = $UILayer/LevelUpPanel/VBoxContainer/LevelUpItemsContainer
@onready var icespear_manager: IcespearManager = %IcespearManager
@onready var tornado_manager: TornadoManager = %TornadoManager
@onready var javelin_manager: JavelinManager = %JavelinManager
@onready var player_hp_bar: PlayerHpBar = %PlayerHpBar
@onready var label_time: Label = %LabelTime
@onready var weapon_icon_container: GridContainer = %WeaponIconContainer
@onready var upgrade_icon_container: GridContainer = %UpgradeIconContainer
@onready var death_menu: PanelContainer = %DeathMenu
@onready var label_death_title: Label = %LabelDeathTitle
@onready var audio_lose: AudioStreamPlayer = %AudioLose


const UPGRADE_ITEM_ICON = preload("res://UpgradeItemIcon/upgrade_item_icon.tscn")
const LEVEL_UP_OPTION_ITEM = preload("res://LevelUpOptionItem/level_up_option_item.tscn")
var move_speed = 5000
var mov = Vector2(0, 0)
var health = 10.
var maxhealth = 10.
var enemy_close: Array[Enemy] = []
var lastmove = Vector2.UP
var level = 0:
	set(val):
		level = val
		label_level.text = 'Level ' + str(val)
var exp_collected = 0.
var exp_level = 10. # 当前级别升级需要的经验
var upgrade_max = 3
var upgrade_collected = {} # 已经获得的升级


var icespear_level = 0
var icespear_baseammo = 0
var tornado_level = 0
var tornado_baseammo = 0
var tornado_attackspeed = 0
var javelin_level = 0
var javelin_ammo = 0
var armor = 0
var spell_size = 1.
var spell_cooldown = 0
var additional_attacks = 0


func _ready() -> void:
	upgrade_chosed.connect(icespear_manager.on_player_upgrade)
	upgrade_chosed.connect(tornado_manager.on_player_upgrade)
	upgrade_chosed.connect(javelin_manager.on_player_upgrade)
	hp_change.connect(player_hp_bar.on_player_hp_change)
	
	upgrade('icespear1')
	upgrade_chosed.emit()




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


func _on_hurt_box_hurt(hurt_box_owner, hit_obj) -> void:
	health -= clamp(hit_obj.damage, 1, hit_obj.damage - armor)
	hp_change.emit(health, maxhealth)
	if health <= 0:
		var is_kill_by_death_god = hit_obj.owner.enemy_type == 'death_god'
		handle_death(is_kill_by_death_god)

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
		show_upgrade_options()
		await upgrade_chosed
		exp_collected -= exp_level
		level += 1
		exp_level = level * 10
		level_up()

# 升级项被选择
func upgrade(upgrade_key):
	if UpgradeDb.UPGRADES[upgrade_key].type != 'item':
		var upgrade_item = UpgradeDb.UPGRADES[upgrade_key]
		upgrade_collected[upgrade_key] = upgrade_item
		
		# 判断重复的图标->不展示
		var is_have_icon = upgrade_collected.values().filter(func (item): return item.displayname == upgrade_item.displayname).size() > 1
		if not is_have_icon:
			var upgrade_icon = UPGRADE_ITEM_ICON.instantiate()
			upgrade_icon.upgrade_key = upgrade_key
			if upgrade_item.type == 'weapon':
				weapon_icon_container.add_child(upgrade_icon)
			if upgrade_item.type == 'upgrade':
				upgrade_icon_container.add_child(upgrade_icon)
	hide_upgrade_options()
	match upgrade_key:
		"icespear1":
			icespear_level = 1
			icespear_baseammo += 1
		"icespear2":
			icespear_level = 2
			icespear_baseammo += 1
		"icespear3":
			icespear_level = 3
		"icespear4":
			icespear_level = 4
			icespear_baseammo += 2
		"tornado1":
			tornado_level = 1
			tornado_baseammo += 1
		"tornado2":
			tornado_level = 2
			tornado_baseammo += 1
		"tornado3":
			tornado_level = 3
			tornado_attackspeed -= 0.5
		"tornado4":
			tornado_level = 4
			tornado_baseammo += 1
		"javelin1":
			javelin_level = 1
			javelin_ammo = 1
		"javelin2":
			javelin_level = 2
		"javelin3":
			javelin_level = 3
		"javelin4":
			javelin_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			move_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			additional_attacks += 1
		"food":
			health += 20.
			health = clamp(health, 0., maxhealth)
			hp_change.emit(health, maxhealth)


func get_random_upgrade_items():
	var item_can_chosed = []
	for item_key in UpgradeDb.UPGRADES:
		var item = UpgradeDb.UPGRADES[item_key]
		# 先不选择item类型的升级
		if item.type == 'item':
			pass
		# 已经拥有的升级
		if upgrade_collected.keys().has(item_key):
			pass
		# 已经进行选择的升级
		elif item_can_chosed.has(item_key):
			pass
		#不满足前置条件的升级
		elif item.prerequisite.size() > 0:
			var can_add = true
			for prerequisite in item.prerequisite:
				if not upgrade_collected.keys().has(prerequisite):
					can_add = false
			if can_add:
				item_can_chosed.append(item_key)
		else:
			item_can_chosed.append(item_key)
	
	var upgrade_items = []
	var n = 0
	while n < upgrade_max:
		if item_can_chosed.size() > 0:
			var random_item = item_can_chosed.pick_random()
			upgrade_items.append(random_item)
			item_can_chosed.erase(random_item)
		else:
			# 不足的升级项目用食物补全
			upgrade_items.append('food')
		n += 1

	return upgrade_items


func spawn_upgrade_item():
	for child in level_up_items_container.get_children():
		child.queue_free()

	var upgrade_chosed = get_random_upgrade_items()
	for item_key in upgrade_chosed:
		var upgrade_item = UpgradeDb.UPGRADES[item_key]
		var item = LEVEL_UP_OPTION_ITEM.instantiate()
		item.key = item_key
		item.item_icon = load(upgrade_item.icon)
		item.item_name = upgrade_item.displayname
		item.item_level = str(upgrade_item.level)
		item.item_description = upgrade_item.details
		item.selected_upgrade.connect(upgrade)
		level_up_items_container.add_child(item)


func show_upgrade_options():
	get_tree().paused = true
	audio_level_up.play()
	spawn_upgrade_item()
	
	var tween = level_up_panel.create_tween()
	var view_width = get_viewport_rect().size.x
	var panel_width = level_up_panel.size.x
	tween.tween_property(level_up_panel, "position", Vector2(view_width / 2. - panel_width / 2., 30), 0.35).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)


func hide_upgrade_options():
	level_up_panel.position = Vector2(680, 30)
	get_tree().paused = false
	upgrade_chosed.emit()


func on_time_change(seconds):
	var m = int(seconds / 60)
	var s = seconds - m * 60
	var mm = str(m) if m >= 10 else ('0'+str(m))
	var ss = str(s) if s >= 10 else ('0'+str(s))
	label_time.text = mm + ':' + ss


func handle_death(is_kill_by_death_god):
	death.emit()
	if is_kill_by_death_god:
		label_death_title.text = 'You Win'
	else:
		label_death_title.text = 'You lose'
	get_tree().paused = true
	show_death_menu()
	


func show_death_menu():
	audio_lose.play()
	var view_width = get_viewport_rect().size.x
	var tween = death_menu.create_tween()
	tween.tween_property(death_menu, 'position', Vector2(view_width / 2. - death_menu.size.x / 2., 130.), 1.35).set_ease(Tween.EASE_OUT)


func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://StartMenu/start_menu.tscn")
