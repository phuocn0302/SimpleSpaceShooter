extends Node2D

@export var laser_stat: LaserResource

@export var active: bool = false:
	get:
		return active
	set(value):
		active = value
		if active:
			if shoot_timer and shoot_timer.is_stopped(): 
				shoot_timer.start(shoot_interval)
		else:
			if shoot_timer: shoot_timer.stop()
		
@export var show_warning: bool = false:
	get:
		return show_warning
	set(value):
		show_warning = value
		set_process(show_warning)
		if warn_line: warn_line.visible = show_warning

@export var use_texture_width: bool = false
@export var alway_show_warn_line: bool = false

@export var shoot_interval: float = 5:
	get:
		return shoot_interval
	set(value):
		shoot_interval = value
		if shoot_timer: shoot_timer.wait_time = shoot_interval
		
@onready var warn_line = $WarnLine
@onready var shoot_timer = $ShootTimer
@onready var launch_effect = $LaunchEffect

var LaserScene = preload("res://Scenes/BulletStuff/laser.tscn")

var warn_line_point: Vector2:
	get:
		return warn_line_point
	set(point):
		warn_line_point = point
		warn_line.points = [Vector2.ZERO, warn_line_point]

var function = GlobalFunction as Global_Function
var player 

signal shot

func _ready():
	shoot_timer.wait_time = shoot_interval
	active = active
	show_warning = show_warning

func _process(_delta):
	var tween = get_tree().create_tween().set_parallel(true)
	tween.tween_property(self, "warn_line_point", laser_stat.velocity * laser_stat.distance, 0.1)
	
	var width = laser_stat.laser_width
	if use_texture_width and laser_stat.laser_texture:
		width = laser_stat.laser_texture.get_height() * 0.5
	
	if alway_show_warn_line:
		tween.tween_property(warn_line, "width", width, 0.1)
	elif shoot_timer.time_left <= 1:
		tween.tween_property(warn_line, "width", width, 0.1)
	if shoot_timer.time_left <= 0.5:
		tween.tween_property(warn_line, "width", 0, 0.1)

func shoot():
	shot.emit()
	launch_effect.rotation = laser_stat.velocity.angle()
	launch_effect.set_deferred("emitting", true)
	var laser = function.instantiate_scene(LaserScene, 
	global_position, get_tree().current_scene) as Laser
	if laser_stat: laser.laser_stat = laser_stat
	
