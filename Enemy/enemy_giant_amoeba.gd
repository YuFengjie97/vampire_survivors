extends Enemy
class_name EnemyGiantAmoeba


func _ready():
	super._ready()
	move_speed = 30000
	health = 99999
	knockback = Vector2.ZERO
	knockback_recory = 999
	experience = 0
	damage = 9999
