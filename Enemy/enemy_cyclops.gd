extends Enemy
class_name EnemyCyclops

func _ready():
	super._ready()
	move_speed = 3500
	health = 40
	knockback = Vector2.ZERO
	knockback_recory = 40
	experience = 50
	damage = 8
