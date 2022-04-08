extends KinematicBody2D

const Plasma = preload("res://Object/Supplement/GroupingPlasma.tscn")
const plasmaBullet = preload("res://Object/Supplement/PlasmaBullet.tscn")

export var speed = 100
export var acceleration = 500
export var friction = 100

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var Aim_direction = Vector2.ZERO
var cooldown = false


onready var sprite = $Sprite
onready var aimPoint = $AimPoint
onready var stats_UI = $StatsUI

func _ready():
	PlayerStats.connect("no_health", self, "queue_free")
	randomize()

func _physics_process(delta):
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(speed * direction, acceleration * delta)
		
		$Sprite.flip_h = direction.x < 0
	else:
		direction = direction
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		$Sprite.flip_h = $Sprite.flip_h
	
	velocity = move_and_slide(velocity)
	
	Aim_direction = Vector2(
		Input.get_action_strength("Aim_right") - Input.get_action_strength("Aim_left"), 
		Input.get_action_strength("Aim_down") - Input.get_action_strength("Aim_up") 
	).normalized()
	
	Aim_direction = get_local_mouse_position()
	
	if Aim_direction != Vector2.ZERO:
		aimPoint.rotation_degrees = rad2deg(Vector2.ZERO.angle_to_point(-Aim_direction))
	else:
		aimPoint.rotation_degrees = aimPoint.rotation_degrees
	
	if !cooldown and Input.get_action_strength("attack"):
		add_animation()
		cooldown = true
	
	if stats_UI.health * 2 >= stats_UI.max_health:
		$Sprite.frame = 0
	
	if stats_UI.health * 2 <= stats_UI.max_health:
		$Sprite.frame = 1
		
	if stats_UI.health * 4 <= stats_UI.max_health:
		$Sprite.frame = 2
	

func add_animation():
	var grouping = Plasma.instance()
	add_child(grouping)
	grouping.flip_h = Aim_direction.x < 0
	var groupingPlasma = $GroupingPlasma
	groupingPlasma.connect("animation_finished",self,"launch_bullet")

func launch_bullet():
	cooldown = false
	var bullet = plasmaBullet.instance()
	bullet.global_position = global_position
	bullet.global_rotation_degrees = $AimPoint.rotation_degrees
	get_tree().current_scene.add_child(bullet)
	
	var direction = Vector2.ZERO
	var target_direction = $AimPoint/HitBoxes/CollisionShape2D
	
	direction = global_position.direction_to(target_direction.global_position).normalized()
	bullet.velocity = direction * bullet.bullet_speed

func _on_HurtBoxes_body_entered(body: Node) -> void:
	PlayerStats.health -= body.damage

func _on_HurtBoxes_area_entered(area: Area2D) -> void:
	PlayerStats.health -= area.damage
