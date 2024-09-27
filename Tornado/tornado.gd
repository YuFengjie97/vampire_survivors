extends Area2D
class_name Tornado

#@onready var player = get_node('/root/World/Player') as Player
@onready var player = get_tree().get_node('%Player') as Player

var level = 1
var hp = 9999
var damage = 5
var speed = 70
var attack_size = 1.0
var knockback_force = 5000

var direction = Vector2.ZERO
var angle_less = deg_to_rad(-30)
var angle_more = deg_to_rad(30)



func _ready():
	match level:
		1:
			hp = 9999
			damage = 5
			speed = 70
			attack_size = 1.0
			knockback_force = 5000
