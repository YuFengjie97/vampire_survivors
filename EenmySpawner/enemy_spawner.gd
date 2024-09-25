extends Node2D

@export var spawne_info_array: Array[SpawnInfo] = []
var time = 0

@onready var timer: Timer = $Timer
@onready var player: Player = get_tree().get_first_node_in_group('player')


func _on_timer_timeout() -> void:
	time += 1
	for spawn_info in spawne_info_array:
		if time > spawn_info.time_start and time < spawn_info.time_end:
			if spawn_info.spawn_delay_counter < spawn_info.spawn_delay:
				spawn_info.spawn_delay_counter += 1
			else:
				spawn_info.spawn_delay_counter = 0
				var count = 0
				while count < spawn_info.enemy_num:
					var enemy = spawn_info.enemy_scene.instantiate()
					enemy.global_position = get_random_pos()
					add_child(enemy)
					count += 1

func get_random_pos():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var pos_x = player.global_position.x
	var pos_y = player.global_position.y
	var top_left = Vector2(pos_x - vpr.x / 2, pos_y - vpr.y / 2)
	var top_right = Vector2(pos_x + vpr.x / 2, pos_y - vpr.y / 2)
	var bottom_left = Vector2(pos_x - vpr.x / 2, pos_y + vpr.y / 2)
	var bottom_right = Vector2(pos_x + vpr.x / 2, pos_y + vpr.y / 2)
	var direction = ['up','down','left','right'].pick_random()
	var pos = Vector2(0.0, 0.0)
	match direction:
		'up':
			pos.x = randf_range(top_left.x, top_right.x)
			pos.y = randf_range(top_left.y, top_right.y)
		'down':
			pos.x = randf_range(bottom_left.x, bottom_right.x)
			pos.y = randf_range(bottom_left.y, bottom_right.y)
		'left':
			pos.x = randf_range(top_left.x, bottom_left.x)
			pos.y = randf_range(top_left.y, bottom_left.y)
		'right':
			pos.x = randf_range(top_right.x, bottom_right.x)
			pos.y = randf_range(top_right.y, bottom_right.y)
	return pos
