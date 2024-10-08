extends Node
class_name TornadoManager


@onready var attack_timer: Timer = $AttackTimer
@onready var reload_timer: Timer = $ReloadTimer
@onready var player: Player = $"../.."


var level = 0
var ammo = 0
var baseammo = 1
var attack_delay = 0.1
var reload_delay = 1.0
var scene = preload("res://Tornado/tornado.tscn")


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
		var tornado = scene.instantiate() as Tornado
		tornado.level = level
		tornado.additional_size = player.spell_size
		add_child(tornado)
		ammo -= 1
		attack_timer.start()
	else:
		reload_timer.start()


func on_player_upgrade():
	level = player.tornado_level
	baseammo = player.tornado_baseammo + player.additional_attacks
	reload_timer.wait_time = clamp(reload_timer.wait_time - player.spell_cooldown, 0.01, reload_timer.wait_time - player.spell_cooldown)
	attack()
