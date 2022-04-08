extends AnimatedSprite


func _on_AsteroidEffect_animation_finished() -> void:
	queue_free()
