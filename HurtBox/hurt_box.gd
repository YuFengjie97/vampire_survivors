extends Area2D
class_name HurtBox

signal hurt(damage, direction, knockback_force)

enum HurtBoxType { COOLDOWN, HITONCE, HITDISABLE }

@export var current_type: HurtBoxType = HurtBoxType.COOLDOWN
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

var hit_once_array: Array[Area2D] = []


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('hit') and area.get('damage') != null:
		match current_type:
			HurtBoxType.COOLDOWN:
				collision_shape_2d.call_deferred('set', 'disabled', true)
				timer.start()
			HurtBoxType.HITONCE:
				if not hit_once_array.has(area):
					area.remove.connect(remove_from_hit_once_array)
					hit_once_array.append(area)
			HurtBoxType.HITDISABLE:
				if area.has_method('temp_disabled'):
					area.temp_disable()

		# 武器击中敌人后，武器损伤
		if area.has_method('enemy_hit'):
			area.enemy_hit()
		
		# 武器击中敌人，敌人后退
		var knockback_force = 0
		var direction = Vector2.ZERO
		if area.get('knockback_force') != null:
			knockback_force = area.knockback_force
		if area.get('direction') != null:
			direction = area.direction
		
		hurt.emit(area.damage, direction, knockback_force)


func remove_from_hit_once_array(area):
	if hit_once_array.has(area):
		hit_once_array.erase(area)


func _on_timer_timeout() -> void:
	collision_shape_2d.call_deferred('set', 'disabled', false)
