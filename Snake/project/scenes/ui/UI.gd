extends CanvasLayer

func update_score(length_of_snake):
	$Control/Score.text = "Score:" + str(length_of_snake*100)

func _ready():
	$Lose.hide()
	$Credits.hide()
	$ChooseName.show()
	$Control.show()
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func load_scores():
	$HTTPRequest.request("http://dreamlo.com/lb/61c109ba8f40bb3d78dec379/json")

func _on_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	$Lose/Leaderboard/Leaderboard.text = ""
	$Lose/Leaderboard/Leaderboard2.text = ""
	
	for i in range(1, 26):
		var entry = null
		if json.result:
			if len(json.result["dreamlo"]["leaderboard"]["entry"]) > i-1:
				entry = json.result["dreamlo"]["leaderboard"]["entry"][i-1]
			if i <= 13:
				if i < 10:
					$Lose/Leaderboard/Leaderboard.text += " "

				if entry:
					$Lose/Leaderboard/Leaderboard.text += str(i) + ". " + entry.name + ": " + entry.score + "\n"
				else:
					$Lose/Leaderboard/Leaderboard.text += str(i) + ". [ Nobody ]\n"
			else:
				if entry:
					$Lose/Leaderboard/Leaderboard2.text += str(i) + ". " + entry.name + ": " + entry.score + "\n"
				else:
					$Lose/Leaderboard/Leaderboard2.text += str(i) + ". [ Nobody ]\n"

func _process(_delta):
	if get_tree().paused and $Music.playing:
		$Music.stop()
	
	if Input.is_action_pressed("ui_accept") and get_tree().paused and not $ChooseName.visible and $Lose.visible and not $Credits.visible:
		get_tree().paused = false
		$Music.start()
		$Lose.hide()
	elif Input.is_action_pressed("ui_credits") and get_tree().paused and not $ChooseName.visible and $Lose.visible and not $Credits.visible:
		$Credits.show()
	elif Input.is_action_pressed("ui_escape") and get_tree().paused and not $ChooseName.visible and $Lose.visible and $Credits.visible:
		$Credits.hide()

func _on_LineEdit_text_entered(new_name):
	$ChooseName.hide()
	get_parent().player_name = new_name
	get_tree().paused = false
	$Music.start()
