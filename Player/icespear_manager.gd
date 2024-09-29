extends Node
class_name IcespearManager


@onready var attack_timer: Timer = $AttackTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var player: Player = $"../.."


var level = 0
var ammo = 0
var baseammo = 1
var attack_delay = 0.2
var reload_delay = 2.0
var scene = preload("res://Icespear/icespear.tscn")


func _ready() -> void:
	attack_timer.wait_time = attack_delay
	reload_timer.wait_time = reload_delay


func attack():
	if level > 0:
		reload_timer.start()


func _on_reload_timer_timeout() -> void:
	ammo = baseammo
	attack_timer.start()


func _on_attack_timer_timeout() -> void:
	if ammo > 0:
		var icespear = scene.instantiate()
		icespear.level = level
		add_child(icespear)
		ammo -= 1
		attack_timer.start()
	else:
		reload_timer.start()
