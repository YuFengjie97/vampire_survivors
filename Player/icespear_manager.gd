extends Node2D
class_name IcespearManager


@onready var icespear_attack_timer: Timer = $IcespearAttackTimer
@onready var icespear_reload_timer: Timer = $IcespearReloadTimer
@onready var player: Player = $"../.."


var icespear_level = 1
var icespear_ammo = 0
var icespear_baseammo = 1
var icespear_reload_delay = 2.0
var icespear_scene = preload("res://Icespear/icespear.tscn")


func attack():
	if icespear_level > 0:
		icespear_reload_timer.start()


func _on_icespear_reload_timer_timeout() -> void:
	icespear_ammo = icespear_baseammo
	icespear_attack_timer.start()


func _on_icespear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var target = player.get_random_enemy()
		var icespear = icespear_scene.instantiate()
		icespear.target = target
		add_child(icespear)
		icespear_ammo -= 1
		icespear_attack_timer.start()
	else:
		icespear_reload_timer.start()
