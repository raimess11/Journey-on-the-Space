extends Control

var health = 4 setget set_health
var max_health = 4 setget set_max_health

onready var HealthFull = $HealthFull
onready var HealthEmpty = $HealthEmpty

func set_health(value):
	health = clamp(value, 0, max_health)
	if HealthFull != null:
		HealthFull.margin_left = - health * 0.15
		HealthFull.margin_right = health * 0.15

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)
	if HealthEmpty != null:
		HealthEmpty.margin_left = - max_health * 0.15
		HealthEmpty.margin_right = max_health * 0.15
#		HealthEmpty.rect_pivot_offset.x = rect_size.x/2

func _ready():
	var Stats = get_parent().get_node("Stats")
	self.max_health = Stats.max_health
	self.health = Stats.health
	Stats.connect("health_change", self, "set_health")
	Stats.connect("max_health_change", self, "set_max_health")
