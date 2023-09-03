class_name Player
extends CharacterBody2D

var BulletPath = preload("res://Scenes/Player/bullet.tscn")
var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var FlashShader = preload("res://Shaders/flash.gdshader")

@export var speed: float = 9000.0
@export var dash_multipler: float = 2.0
@export var fire_rate: float = 0.2 # Per second
@export var max_hp: int = 3

@onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite2D
@onready var normal_shoot_pos = $NormalShootPos/ShootSpot

var iframe_dur: float = 0.6
var player_dir: Vector2 = Vector2.ZERO

var current_hp: int

var can_move = true
var can_shoot = true
var can_take_damage = true
var can_deal_contact_damage = true
var can_flash = true


func _ready():
	current_hp = max_hp
	anim_player.play("spawn")
	iframe(iframe_dur)

func _process(_delta):
	anim_sprite.play("default")
	$DashAbility.unlock()

func _physics_process(delta):
	get_input(delta)
	move_and_slide()

func get_input(delta):
	var dir = Input.get_vector("left","right","up","down").normalized()
	player_dir = dir
	if can_move:
		velocity = dir * speed * delta
	if (Input.is_action_pressed("shoot")):
		shoot()

func shoot():
	if can_shoot:
		GlobalFunction.instantiate_scene(BulletPath,normal_shoot_pos.global_position, get_parent())
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func iframe(duration):
	can_take_damage = false
	can_deal_contact_damage = false
	await get_tree().create_timer(duration).timeout
	can_take_damage = true
	can_deal_contact_damage = true
	
	anim_player.play("RESET")

func take_damage(damage):
	if can_take_damage:
		current_hp -= damage
		iframe(iframe_dur)
		
		anim_player.play("hit")
		GlobalFunction.camera.shake(0.5,1)
		GlobalFunction.freeze_frame(0.1, 0.3)
		
	if current_hp <=0:
		die()

func flash(flash_dur: float, flash_interval: float):
	can_flash = true
	flashing(flash_interval)
	await get_tree().create_timer(flash_dur).timeout
	can_flash = false

func flashing(interval):
	if can_flash:
		anim_sprite.material.set_shader_parameter("active", true)
		await get_tree().create_timer(interval).timeout
		anim_sprite.material.set_shader_parameter("active", false)
		await get_tree().create_timer(interval).timeout
		flashing(interval)

func die():
	GlobalFunction.instantiate_scene(ExplosionPath, global_position, get_parent())
	GlobalFunction.camera.shake(0,1)
	queue_free()


func _on_hitbox_area_entered(area):
	if area.is_in_group("Enemy"):
		if can_deal_contact_damage:
			area.die()
		take_damage(1)
