extends Node2D

var Bullet = preload("res://Scenes/BulletStuff/enemy_bullet.tscn")

@export var shoot_timer: float = 0.6
@export var bullet_speed: float = 150
@export var spread_deg: float = 15

@onready var muzzle = $Muzzle
@onready var hitbox_component = $HitboxComponent

var time: float = 0
var can_shoot: bool = true

var function = GlobalFunction as Global_Function

signal drone_die

func _ready():
	randomize()

func _process(_delta):
	time = wrapf(time + 0.1, 0, 2 * PI)
	global_position.x += sin(time) * 0.2
	global_position.y += cos(2 * time) * 0.2
	shoot()

func shoot():
	if can_shoot:
		spawn_bullet()
		can_shoot = false
		await get_tree().create_timer(shoot_timer).timeout
		can_shoot = true

func spawn_bullet():
	var bullet = function.instantiate_scene(Bullet, muzzle.global_position, get_tree().current_scene)
	bullet.speed = bullet_speed
	bullet.velocity = Vector2.LEFT.rotated(deg_to_rad(randf_range(-spread_deg, spread_deg)))

func _on_health_component_taking_damage():
	GlobalFunction.flash(self)

func _on_health_component_zero_hp():
	drone_die.emit()
	function.explode_effect(global_position)
	function.screen_shake(0.5, 1)
	hitbox_component.deactive()
	set_process(false)
