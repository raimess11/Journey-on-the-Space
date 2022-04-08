extends AnimatedSprite



func _ready() -> void:
	play("Grouping")


func _on_GroupingPlasma_animation_finished() -> void:
	queue_free()
	
