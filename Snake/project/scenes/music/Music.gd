extends Node

onready var songs = ["res://assets/leap.wav","res://assets/8 Bit Background Music.wav","res://assets/8bit-OnTheOffensive.wav","res://assets/retro.wav"]

var playing = false

func start():
	var num = int(rand_range(0, len(songs)-1))
	if File.new().file_exists(songs[num]):
		var sfx = load(songs[num]) 
		$playing.stream = sfx

	$AnimationPlayer.play("start")
	playing = true

func stop():
	$AnimationPlayer.play("stop")
	playing = false

func _on_playing_finished():
	var num = int(rand_range(0, len(songs)-1))
	if File.new().file_exists(songs[num]):
		var sfx = load(songs[num]) 
		$playing.stream = sfx
	$playing.play()
