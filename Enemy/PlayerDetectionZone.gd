extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body) -> void:
	player = body
	print("iin")


func _on_PlayerDetectionZone_body_exited(body: Node) -> void:
	player = null
