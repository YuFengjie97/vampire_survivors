extends Enemy
class_name EnemyKoboldStrong

func _ready():
	super._ready()
	move_speed = 2600
	health = 20
	knockback = Vector2.ZERO
	knockback_recory = 50
	experience = 20
	damage = 4
