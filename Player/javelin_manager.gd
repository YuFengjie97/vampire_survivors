extends Node
class_name JavelinManager

var javelin_scene = preload("res://Javelin/javelin.tscn")
@onready var player = get_node('/root/World/Player') as Player

var level = 0
var baseammo = 6
var ammo = 0

func attack() -> void:
	if level > 0:
		while ammo < baseammo:
			var javeline = javelin_scene.instantiate() as Javelin
			javeline.level = level
			javeline.attack_delay = clamp(javeline.attack_delay - player.spell_cooldown, 0.01, javeline.attack_delay - player.spell_cooldown)
			add_child(javeline)
			ammo += 1


func on_player_upgrade():
	level = player.javelin_level
	baseammo = player.javelin_ammo + player.additional_attacks
	attack()
	#reload_timer.wait_time -= player.spell_cooldown
