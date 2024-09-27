extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var icespear_manager: IcespearManager = $WeaponManager/IcespearManager
@onready var tornado_manager: TornadoManager = $WeaponManager/TornadoManager


var move_speed = 3000
var mov = Vector2(0, 0)
var health = 100
var enemy_close: Array[Enemy] = []
var lastmove = Vector2.UP


func _ready() -> void:
	icespear_manager.attack()
	tornado_manager.attack()


func _input(_event):
	var x_mov = Input.get_axis('left', 'right')
	var y_mov = Input.get_axis('up', 'down')
	#var x_mov = Input.get_action_strength('right') - Input.get_action_strength('left')
	#var y_mov = Input.get_action_strength('down') - Input.get_action_strength('up')
	mov.x = x_mov
	mov.y = y_mov
	if mov != Vector2.ZERO:
		lastmove = mov
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


func _on_hurt_box_hurt(damage: Variant, _direction, _knockback_force) -> void:
	health -= damage
	if health <= 0:
		pass

func get_random_enemy() -> Vector2:
	if enemy_close.size() > 0:
		return enemy_close.pick_random().position
	return Vector2.UP


func _on_detect_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group('enemy'):
		enemy_close.append(body)


func _on_detect_zone_body_exited(body: Node2D) -> void:
	enemy_close.erase(body)
