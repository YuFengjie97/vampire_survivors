extends Node
class_name IcespearManager


@onready var attack_timer: Timer = $AttackTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var player: Player = $"../.."


var level = 0
var ammo = 0
var baseammo = 0
var attack_delay = 0.2
var reload_delay = 2.0
var scene = preload("res://Icespear/icespear.tscn")


func _ready() -> void:
	attack_timer.wait_time = attack_delay
	reload_timer.wait_time = reload_delay


func attack():
	if level > 0 and reload_timer.is_stopped():
		reload_timer.start()


func _on_reload_timer_timeout() -> void:
	ammo = baseammo
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	if ammo > 0:
		var icespear = scene.instantiate()
		icespear.level = level
		icespear.additional_size = player.spell_size
		add_child(icespear)
		ammo -= 1
		attack_timer.start()
	else:
		reload_timer.start()


func on_player_upgrade():
	level = player.icespear_level
	baseammo = player.icespear_baseammo + player.additional_attacks
	reload_timer.wait_time = clamp(reload_timer.wait_time - player.spell_cooldown, 0.01, reload_timer.wait_time - player.spell_cooldown)
	attack()
