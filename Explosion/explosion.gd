extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_enemy_death: AudioStreamPlayer2D = $AudioEnemyDeath


func _ready() -> void:
	animated_sprite_2d.play('explosion')
	audio_enemy_death.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
