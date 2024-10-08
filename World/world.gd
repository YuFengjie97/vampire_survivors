extends Node2D

@onready var audio_bgm: AudioStreamPlayer = %AudioBgm


func _on_player_death() -> void:
	audio_bgm.playing = false
