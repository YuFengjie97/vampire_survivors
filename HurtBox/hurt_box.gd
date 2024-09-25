extends Area2D
class_name HurtBox

signal hurt(damage)

enum HurtBoxType { COOLDOWN, HITONCE, HITDISABLE }

@export var current_type: HurtBoxType = HurtBoxType.COOLDOWN
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('hit'):
		if not area.get('damage') == null:
			match current_type:
				0:
					collision_shape_2d.call_deferred('set', 'disabled', true)
					timer.start()
				1:
					pass
				2:
					if area.has_method('temp_disabled'):
						area.temp_disable()
			hurt.emit(area.damage)

func _on_timer_timeout() -> void:
	collision_shape_2d.call_deferred('set', 'disabled', false)
