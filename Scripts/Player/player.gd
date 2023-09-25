class_name Player
extends CharacterBody2D

var BulletPath = preload("res://Scenes/Player/bullet.tscn")
var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var FlashShader = preload("res://Shaders/flash.gdshader")

@export var speed: float = 9000.0
@export var dash_multipler: float = 2.0
@export var fire_rate: float = 0.2 # Per second

@onready var anim_player = $AnimationPlayer
@onready var anim_sprite = $AnimatedSprite2D
@onready var normal_shoot_pos = $NormalShootPos/ShootSpot
@onready var hitbox_component = $HitboxComponent as HitboxComponent

var iframe_dur: float = 0.6
var player_dir: Vector2 = Vector2.ZERO

var current_hp: int

var can_move = true
var can_shoot = true
var can_flash = true

var function = GlobalFunction as Global_Function

func _ready():
	Global.player = self
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
		function.instantiate_scene(BulletPath,normal_shoot_pos.global_position, get_parent())
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func iframe(duration):
	hitbox_component.deactivated()
	await get_tree().create_timer(duration).timeout
	hitbox_component.activated()
	function.flash(self)
	anim_player.play("RESET")


func _on_health_component_taking_damage():
	function.flash(self)
	iframe(iframe_dur)
	anim_player.play("hit")
	function.screen_shake(0.5,1)
	function.freeze_frame(0.3, 0.3)


func _die():
	Global.player = null
	function.explode_effect(global_position)
	queue_free()
