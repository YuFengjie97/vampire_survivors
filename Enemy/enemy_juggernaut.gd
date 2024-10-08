extends Enemy
class_name EnemyJuggernaut


func _ready():
	super._ready()
	move_speed = 3000
	health = 20
	knockback = Vector2.ZERO
	knockback_recory = 40
	experience = 30
	damage = 6
