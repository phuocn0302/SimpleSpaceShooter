extends Node2D

@export var raygun_interval: float = 5

@onready var health = $HealthComponent as HealthComponent
@onready var raygun_muzzle = $RayGun/Muzzle
@onready var ray_gun = $RayGun
@onready var missile_spawner = $RocketLauncher/MissileSpawner
@onready var raygun_active = $RaygunActive


var LaserScene = preload("res://Scenes/BulletStuff/laser.tscn")

var t: float = 0


var function = GlobalFunction as Global_Function
var player = null

enum States {
	PHASE1,
	PHASE2,
	PHASE3
}

var current_state: States:
	get:
		return current_state
	set(value):
		current_state = value
		if value == States.PHASE1:
			raygun_active.start(raygun_interval)

# Phase 1: Follow player and shoot laser, homing missle
# Phase 2: At around 60% health, change to phase 2, increase fire rate
# Phase 3: Below 30% health, shooting big laser cover half the screen 
# randomly with a short advance warning


# Called when the node enters the scene tree for the first time.
func _ready():
	current_state = States.PHASE1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = Global.player as Player
	match current_state:
		States.PHASE1:
			move(delta)
			missile_spawner.active = true
			missile_spawner.shoot_interval = 3
		States.PHASE2:
			move(delta)
			missile_spawner.shoot_interval = 2
			raygun_active.wait_time = 1
		States.PHASE3:
			pass


func move(delta):
	
	if player != null:
		global_position.y = lerp(global_position.y, player.global_position.y, 2 * delta)
#		global_position.y = move_toward(global_position.y, player.global_position.y, 50 * delta)
	
	
	t = fposmod(t + 0.1, 2 * PI)
	global_position.x += sin(t) * 0.25
	global_position.y += cos(t) * 0.25
	


func raygun_shoot():
	function.instantiate_scene(LaserScene, raygun_muzzle.global_position, get_tree().current_scene)
	
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING) 
	tween.tween_property(ray_gun, "position", ray_gun.position + Vector2(10, 0), 0.1)
	tween.tween_property(ray_gun, "position", ray_gun.position, 1)

func _on_health_component_taking_damage():
	function.flash(self)
	
	if health.current_hp <= health.max_hp * 0.6 and current_state == States.PHASE1:
			current_state = States.PHASE2


func _on_health_component_zero_hp():
	function.explode_effect(global_position)
	function.freeze_frame(0.5, 1)
	queue_free()


func _on_raygun_active():
	raygun_shoot()
