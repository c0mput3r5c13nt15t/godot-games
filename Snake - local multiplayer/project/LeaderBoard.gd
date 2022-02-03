extends Node

signal score_posted()

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func save_score(player_name, length_of_snake):
	$HTTPRequest.request("http://dreamlo.com/lb/fEy7jOe69UW61O97-x5Sgw_iBvyqKMeUS3cZIeyr4-Sg/add/" + player_name + "/" + str(length_of_snake*100))

func _on_request_completed(_result, _response_code, _headers, _body):
	emit_signal("score_posted")
