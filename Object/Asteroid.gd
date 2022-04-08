extends StaticBody2D

const Effect = preload("res://Effect/AsteroidEffect.tscn")

export var damage = 50



func _on_HurtBoxes_area_entered(area: Area2D) -> void:
	var effect = Effect.instance()
	get_tree().current_scene.add_child(effect)
	effect.global_position = global_position
	effect.play("Animate")
	queue_free()
	
