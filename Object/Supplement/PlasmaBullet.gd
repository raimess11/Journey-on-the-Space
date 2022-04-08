extends KinematicBody2D

const Destroyed = preload("res://Object/Supplement/IceCometDestroyed.tscn")

var velocity = Vector2.ZERO
export var bullet_speed = 300

onready var timer = $Timer

func _ready() -> void:
	set_process(true)
	timer.start(1.5)

func _process(delta: float) -> void:
	velocity = move_and_slide(velocity)

func _on_Timer_timeout() -> void:
	queue_free()


func _on_HitBoxes_body_entered(body: Node) -> void:
	var destroyed = Destroyed.instance()
	get_tree().current_scene.add_child(destroyed)
	destroyed.global_position = global_position
	destroyed.global_rotation = global_rotation
	queue_free()
func _on_HitBoxes_area_entered(area: Area2D) -> void:
	var destroyed = Destroyed.instance()
	get_tree().current_scene.add_child(destroyed)
	destroyed.global_position = global_position
	destroyed.global_rotation = global_rotation
	queue_free()
