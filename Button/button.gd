extends Button

@onready var audio_hover: AudioStreamPlayer2D = %AudioHover
@onready var audio_click: AudioStreamPlayer2D = %AudioClick


func _on_pressed() -> void:
	audio_click.play()


func _on_mouse_entered() -> void:
	audio_hover.play()
