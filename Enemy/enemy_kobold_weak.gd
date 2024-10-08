extends Enemy
class_name EnemyKoboldWeak



func _ready():
	super._ready()
	move_speed = 2500
	health = 10
	knockback = Vector2.ZERO
	knockback_recory = 30
	experience = 10
	damage = 2
