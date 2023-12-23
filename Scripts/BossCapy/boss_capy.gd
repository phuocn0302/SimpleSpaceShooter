extends Node2D

@export var init_state: States = States.PHASE1

@onready var health = $HealthComponent as HealthComponent

@onready var ray_gun = $RayGun
@onready var missile_spawner = $RocketLauncher/MissileSpawner
@onready var laser_spawner = $RayGun/LaserSpawner




var LaserScene = preload("res://Scenes/BulletStuff/laser.tscn")
var LaserPhase1 = preload("res://Resources/BulletStuff/LaserDefaultStat.tres")
var LaserPhase2 = preload("res://Scripts/BossCapy/LaserPhase2.tres")
var LaserPhase3 = preload("res://Scripts/BossCapy/LaserPhase3.tres")


var t: float = 0
var function = GlobalFunction as Global_Function
var player = null

# Phase 1: Follow player and shoot laser, homing missle
# Phase 2: At around 60% health, change to phase 2, increase fire rate
# Phase 3: Below 30% health, shooting big laser cover half the screen 
# randomly with a short advance warning


enum States {
	PHASE1,
	PHASE2,
	PHASE3
}

signal change_state(new_state: States)

var current_state: States:
	get:
		return current_state
	set(state):
		current_state = state
		change_state.emit(state)
		match current_state:
			States.PHASE1:
				missile_spawner.active = true
				missile_spawner.shoot_interval = 3
				
				laser_spawner.active = true
				laser_spawner.laser_stat = LaserPhase1
				
			States.PHASE2:
				missile_spawner.active = true
				missile_spawner.shoot_interval = 2
				
				laser_spawner.active = true
				laser_spawner.laser_stat = LaserPhase2
				laser_spawner.shoot_interval = 1
			States.PHASE3:
				missile_spawner.active = true
				missile_spawner.shoot_interval = 1
				
				laser_spawner.laser_stat = LaserPhase3
				laser_spawner.shoot_interval = 4.5 + laser_spawner.shoot_interval
				laser_spawner.active = false
				await get_tree().create_timer(3 - laser_spawner.shoot_interval).timeout
				laser_spawner.active = true
				laser_spawner.show_warning = true



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	global_position = Vector2(270, 90)
	current_state = init_state


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = Global.player as Player
	move_circle()
	match current_state:
		States.PHASE1:
			move(delta)
		States.PHASE2:
			move(delta)
		States.PHASE3:
			move_to(Vector2(300,90), delta)


func move(delta):
	if player != null:
		global_position.y = lerp(global_position.y, player.global_position.y, 2 * delta)

func move_to(pos, delta):
	global_position = lerp(global_position, pos, delta)

func move_circle():
	t = fposmod(t + 0.1, 2 * PI)
	global_position.x += sin(t) * 0.25
	global_position.y += cos(t) * 0.25

func raygun_shoot():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_SPRING) 
	tween.tween_property(ray_gun, "position", ray_gun.position + Vector2(10, 0), 0.1)
	tween.tween_property(ray_gun, "position", ray_gun.position, 1)

func _on_health_component_taking_damage():
#	function.flash(self)
	
	if health.current_hp <= health.max_hp * 0.6 and current_state == States.PHASE1:
		current_state = States.PHASE2
	if health.current_hp <= health.max_hp * 0.2 and current_state == States.PHASE2:
		current_state = States.PHASE3

func _on_health_component_zero_hp():
	function.explode_effect(global_position)
	function.freeze_frame(0.5, 1)
	queue_free()


func _on_change_state(new_state):
	if new_state != States.PHASE1:
		function.explode_effect(global_position, 2)
		function.screen_shake(0.2)
		function.freeze_frame(0.3, 0.3)
		
		var tween = get_tree().create_tween()
		tween.tween_property($Main, "rotation", deg_to_rad(10), 0.2)
		tween.tween_property($Main, "rotation", 0, 0.2)
