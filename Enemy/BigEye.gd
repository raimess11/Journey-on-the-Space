extends KinematicBody2D

const WhiteEnergy = preload("res://Object/Supplement/GroupingWhiteEnergy.tscn")
const WhiteEnergyPulse =preload("res://Object/Supplement/WhiteEnergyPulse.tscn")

enum{
	Idle,
	Wander,
	Chase
}
export var acceleration = 200
export var speed = 50
export var friction = 100


var velocity = Vector2.ZERO

var state = Idle

var cooldown: bool = false

onready var Stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationSprite = $AnimatedSprite
onready var aimPoint = $AimPoint
onready var wanderController = $WanderControl

func _ready() -> void:
	state = pick_random_state([Idle, Wander])


func _physics_process(delta):
	match state:
		Idle:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			
			var player = playerDetectionZone.player
			
			if player != null and global_position.distance_to(player.global_position) > 100:
				var direction = global_position.direction_to(player.global_position).normalized()
				animationSprite.flip_h = direction.x > 0
			
			if !cooldown and player != null and global_position.distance_to(player.global_position) < 150:
				var rotation = global_position.angle_to_point(player.global_position)
				aimPoint.rotation_degrees = rad2deg(rotation)
				add_animation()
			
			if wanderController.get_time_left() == 0:
				update_state()
		Wander:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_state()
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * speed, acceleration * delta)
			animationSprite.flip_h = direction.x > 0
			
			if global_position.distance_to(wanderController.target_position) < 4:
				update_state()
		Chase:
			var player = playerDetectionZone.player
			if player != null and global_position.distance_to(player.global_position) > 100:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * speed, acceleration * delta)
				animationSprite.flip_h = direction.x > 0
			elif player != null and global_position.distance_to(player.global_position) < 100:
				velocity = velocity.move_toward(Vector2.ZERO,friction * delta)
			else:
				state = Idle
			
			if !cooldown and player != null and global_position.distance_to(player.global_position) < 150:
				var rotation = global_position.angle_to_point(player.global_position)
				aimPoint.rotation_degrees = rad2deg(rotation)
				add_animation()
			
			if cooldown:
				var groupingWhiteEnergy = $GroupingWhiteEnergy
				groupingWhiteEnergy.global_position = Vector2(global_position.x + 8.5 if $AnimatedSprite.flip_h else global_position.x - 8.5, global_position.y)
	
	
	velocity = move_and_slide(velocity)


func seek_player():
	if playerDetectionZone.can_see_player():
		state = Chase
		print("i can seeeee you.....")

func update_state():
	state = pick_random_state([Wander, Idle])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func add_animation():
	var grouping = WhiteEnergy.instance()
	add_child(grouping)
	grouping.flip_h = $AnimatedSprite.flip_h
	var groupingWhiteEnergy = $GroupingWhiteEnergy
	groupingWhiteEnergy.connect("animation_finished",self,"launch_bullet")
	cooldown = true

func launch_bullet():
	var bullet = WhiteEnergyPulse.instance()
	bullet.global_position = global_position
	bullet.global_rotation_degrees = $AimPoint.rotation_degrees
	get_tree().current_scene.add_child(bullet)
	var direction = Vector2.ZERO
	var target_direction = $AimPoint/HitBoxes
	
	direction = global_position.direction_to(target_direction.global_position).normalized()
	bullet.velocity = direction * bullet.bullet_speed
	
	cooldown = false

func _on_HurtBoxes_area_entered(area):
	Stats.health -= area.damage
	print("aaaw")


func _on_Stats_no_health() -> void:
	queue_free()
