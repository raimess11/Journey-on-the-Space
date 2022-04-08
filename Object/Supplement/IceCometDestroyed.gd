extends AnimatedSprite



func _on_IceCometDestroyed_animation_finished() -> void:
	queue_free()
