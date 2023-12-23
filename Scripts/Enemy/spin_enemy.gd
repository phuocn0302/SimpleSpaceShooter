extends BaseEnemy
class_name SpinEnemy


@export var stat_resouces: BaseEnemyResource
@export var init_velocity: Vector2
@export var rotation_deg: float = 210
@export var bullet_scene: Resource
@export var shoot_interval: float = 0.5
@export var bullet_speed: float = 100

@onready var rotator: Node2D = $Rotator
@onready var shoot_timer: Timer = $ShootTimer

var function = GlobalFunction as Global_Function

func _ready() -> void:
	shoot_timer.wait_time = shoot_interval
	shoot_timer.start()
	
	init_velocity = init_velocity.normalized()
	self.stat = stat_resouces
	self.move_dir = init_velocity

func _process(delta: float) -> void:
	rotator.rotation_degrees = fposmod(rotator.rotation_degrees + 
		rotation_deg * delta, 360)
	straight_move()

func shoot() -> void:
	var shoot_pos1 = $Rotator/Gun1/ShootPos.global_position
	var shoot_pos2 = $Rotator/Gun2/ShootPos.global_position
	var shoot_pos3 = $Rotator/Gun3/ShootPos.global_position
	var shoot_pos4 = $Rotator/Gun4/ShootPos.global_position
		
	var shoot_pos = [shoot_pos1,
					shoot_pos2,
					shoot_pos3,
					shoot_pos4]
	
	for i in shoot_pos:
		var bullet = function.instantiate_scene(bullet_scene, i, get_tree().current_scene) as Enemy_Bullet
		bullet.velocity = i - global_position
		bullet.speed = bullet_speed


func _worldbound_entered(body: Node2D) -> void:
	if body.is_in_group("ScreenBound"):
		self.move_dir.y *= -1

func _die() -> void:
	GlobalFunction.explode_effect(self.global_position)
	self.queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
