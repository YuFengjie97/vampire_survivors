extends MarginContainer
class_name LevelUpOptionItem

signal selected_upgrade(item)


@onready var icon: TextureRect = %Icon
@onready var label_name: Label = %LabelName
@onready var label_level: Label = %LabelLevel
@onready var label_des: Label = %LabelDes


@export var item_icon = preload("res://Textures/Items/Weapons/ice_spear.png")
@export var item_name = "name"
@export var item_level = 10
@export var item_description = 'this is description'
var mouse_over = false

func _ready():
	icon.texture = item_icon
	label_name.text = item_name
	label_des.text = item_description
	label_level.text = 'level ' + str(item_level)


func _input(event: InputEvent) -> void:
	if event.is_action("click") and mouse_over:
		selected_upgrade.emit({ 'name': item_name, 'level': item_level })


func _on_panel_container_mouse_entered() -> void:
	mouse_over = true

func _on_panel_container_mouse_exited() -> void:
	mouse_over = false
