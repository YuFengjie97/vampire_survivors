extends CharacterBody2D
class_name Player

var move_speed = 2000
var mov = Vector2(0, 0)

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _input(_event):
	#var x_mov = Input.get_axis('left', 'right')
	#var y_mov = Input.get_axis('up', 'down')
	#mov.x = x_mov
	#mov.y = y_mov
	#mov = mov.normalized()
	var x_mov = Input.get_action_strength('right') - Input.get_action_strength('left')
	var y_mov = Input.get_action_strength('down') - Input.get_action_strength('up')
	mov.x = x_mov
	mov.y = y_mov
	mov = mov.normalized()
	if mov.length() > 0:
		animated_sprite_2d.play('walk')
	else:
		animated_sprite_2d.play('idle')
	if x_mov > 0:
		animated_sprite_2d.flip_h = true
	if x_mov < 0:
		animated_sprite_2d.flip_h = false

func _physics_process(delta: float) -> void:
	velocity = mov * move_speed * delta
	move_and_slide()
