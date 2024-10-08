extends Control




func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_button_exit_pressed() -> void:
	get_tree().quit()
