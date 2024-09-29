extends Area2D
class_name HurtBox

signal hurt(hurt_box_owner, hit_obj)

enum HurtBoxType { COOLDOWN, HITONCE, HITDISABLE }

@export var current_type: HurtBoxType = HurtBoxType.COOLDOWN
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@onready var hurt_box_owner = owner

var hit_once_array: Array[Area2D] = []


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('hit') and area.get('damage') != null:
		match current_type:
			HurtBoxType.COOLDOWN:
				collision_shape_2d.call_deferred('set', 'disabled', true)
				timer.start()
			HurtBoxType.HITONCE:
				if not hit_once_array.has(area):
					if area.has_signal('remove_from_hit_once') and not area.remove_from_hit_once.is_connected(remove_from_hit_once_array):
						area.remove_from_hit_once.connect(remove_from_hit_once_array)
					hit_once_array.append(area)
				else:
					return
			HurtBoxType.HITDISABLE:
				if area.has_method('temp_disabled'):
					area.temp_disable()


		# 武器击中敌人后，武器损伤
		if area.has_method('enemy_hit'):
			area.enemy_hit()
		
		# 武器击中敌人，敌人后退
		hurt.emit(hurt_box_owner, area)


func remove_from_hit_once_array(area):
	if hit_once_array.has(area):
		hit_once_array.erase(area)


func _on_timer_timeout() -> void:
	collision_shape_2d.call_deferred('set', 'disabled', false)
