extends AnimatedSprite


func _ready() -> void:
	play("Grouping")


func _on_GroupingWhiteEnergy_animation_finished() -> void:
	queue_free()
