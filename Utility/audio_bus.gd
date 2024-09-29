extends Node

var num_players = 8 # 可供使用的audio个数
var bus = "master"

var available = []  # 可使用的player节点
var queue = []  # 需要播放的音频路径队列


func _ready():
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus


func _on_stream_finished(stream):
	# 当音频播放完毕，将player重新放回可供使用的数组中
	available.append(stream)


func play(sound_path, pitch_scale = 1, volume_db = 1):
	queue.append({ 'sound_path': sound_path, 'pitch_scale': pitch_scale, 'volume_db': volume_db })


func _process(_delta):
	# 播放需要播放的音频
	if not queue.is_empty() and not available.is_empty():
		var sound_info = queue.pop_front()
		var sound_path = sound_info.sound_path
		var pitch_scale = sound_info.pitch_scale
		var volume_db = sound_info.volume_db
		available[0].stream = load(sound_path)
		available[0].pitch_scale = pitch_scale
		available[0].volume_db = volume_db
		available[0].play()
		available.pop_front()
