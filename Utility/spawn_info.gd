extends Resource
class_name SpawnInfo

#敌人会在这个时间段内不断生成
@export var time_start = 0
@export var time_end = 0
@export var enemy_scene: PackedScene
#每波生成敌人数量
@export var enemy_num = 0
#每波的时间间隔
@export var spawn_delay = 0

#内置时间间隔计数器
var spawn_delay_counter = 0
