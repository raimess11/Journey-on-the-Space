extends AnimatedSprite


func _on_WhiteEnergyColape_animation_finished() -> void:
	queue_free()
