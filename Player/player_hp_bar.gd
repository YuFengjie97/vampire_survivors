extends TextureProgressBar
class_name PlayerHpBar

@onready var player = get_tree().get_first_node_in_group('player') as Player

func _ready() -> void:
	value = 100.

func on_player_hp_change(hp, hp_max):
	print(value)
	value = hp / hp_max * 100.


func _process(_delta: float) -> void:
	global_position = player.global_position + Vector2(-16., 16.)
