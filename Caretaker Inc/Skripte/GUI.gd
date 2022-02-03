extends CanvasLayer

var paused = false
var texts = []
var texts_index = 0
var read_time = 4

func _ready():
	get_tree().paused = true

	$Mainmenu.show()
	$Game.show()
	$Game/Confirm.hide()
	$Credits.hide()
	$Paused.hide()
	$Win.hide()
	$Lose.hide()

func dialog(new_texts=[]):
	texts = new_texts
	texts_index = 0
	$Game/Dialog/Text.text = texts[texts_index]
	$Anim.play("Text")
	$Game/Dialog.show()

func tutorial():
	get_tree().paused = true
	$Tutorial.show()

func leave():
	get_tree().paused = true
	$Game/Confirm.show()

func _on_Yes_pressed():
	get_parent().leave()
	$Game/Confirm.hide()

func _on_No_pressed():
	get_tree().paused = false
	$Game/Confirm.hide()

func win(text=''):
	get_tree().paused = true
	$Win/Text.text = text
	$Win.show()

func lose(text=''):
	get_tree().paused = true
	$Lose/Text.text = text
	$Lose.show()

func _on_Play_pressed():
	get_parent().reset()
	get_tree().paused = false
	$Mainmenu.hide()

func _on_Credits_pressed():
	$Credits.show()

func _on_Back_pressed():
	$Credits.hide()

func _on_Exit_pressed():
	get_tree().quit()

func _on_Pause_pressed():
	if paused == false:
		get_tree().paused = true
		$Paused.show()
		paused = true
	else:
		get_tree().paused = false
		$Paused.hide()
		paused = false

func _on_Next_pressed():
	get_parent().next_level()
	get_tree().paused = false
	$Win.hide()

func _on_Retry_pressed():
	get_parent().retry()
	get_tree().paused = false
	$Lose.hide()

func finished():
	$Mainmenu.show()
	get_tree().paused = true

func _on_Ok_pressed():
	$Tutorial.hide()

func _on_Anim_animation_finished(_anim_name):
	$NextText.start(read_time)

func _on_NextText_timeout():
	texts_index += 1
	if texts_index < texts.size():
		$Game/Dialog/Text.text = texts[texts_index]
		$Anim.play("Text")
		$Game/Dialog.show()
	else:
		$Game/Dialog.hide()
