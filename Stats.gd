extends Node2D

export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health
signal health_change(value)
signal max_health_change(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_change", max_health)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0 :
		emit_signal("no_health")
		get_tree().change_scene("res://Game Over Scene.tscn")

func _ready():
	self.health = max_health
