extends Node
class_name JavelinManager

var javelin_scene = preload("res://Javelin/javelin.tscn")
@onready var player = get_node('/root/World/Player') as Player

var level = 1
var num_max = 1
var num = 0

func attack() -> void:
	if level > 0:
		while num < num_max:
			var javeline = javelin_scene.instantiate() as Javelin
			javeline.level = level
			add_child(javeline)
			num += 1
