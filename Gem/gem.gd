extends Area2D
class_name Gem


@onready var audio_collected: AudioStreamPlayer2D = $AudioCollected
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


const GEM_BLUE = preload("res://Textures/Items/Gems/Gem_blue.png")
const GEM_GREEN = preload("res://Textures/Items/Gems/Gem_green.png")
const GEM_RED = preload("res://Textures/Items/Gems/Gem_red.png")

@export var experience = 5
var target = null
var speed = -1

func _ready():
	if experience >= 10:
		sprite_2d.texture = GEM_RED
	elif experience >= 5:
		sprite_2d.texture = GEM_GREEN
	elif experience >= 0:
		sprite_2d.texture = GEM_BLUE

func _physics_process(delta: float) -> void:
	if target != null:
		position = position.move_toward(target.position, speed)
		speed += 2 * delta


func collected():
	sprite_2d.visible = false
	call_deferred('set', 'disabled', true)
	audio_collected.play()
	return experience


func _on_audio_collected_finished() -> void:
	call_deferred("queue_free")
