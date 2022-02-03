extends Node2D

var value = 1

const colors = [Color("#FF0000"), Color("#FF9966"), Color("#FFFA66"), 
				Color("#66FF66"), Color("66FFFD"), Color("#6699FF"),
				Color("7966FF"), Color("F366FF")]

func _ready():
	if int(rand_range(0, 11)) == 5:
		$ColorChange.start()
		value = 2

func _on_ColorChange_timeout():
	$Sprite.self_modulate = colors[randi() % colors.size()]
