extends Area2D

var ExplosionPath = preload("res://Scenes/explosion.tscn")
var BulletPath = preload("res://Scenes/enemy_bullet.tscn")

var contact_damage: int = 1
var can_shoot: bool = true
var rotate_dir: int  = -1
var current_hp: float = 50

@export var fire_rate: float = 0.1
@export var rotate_speed: float = 2
@export var max_hp: float = 50

@onready var player = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Rotator.rotate(rotate_dir * rotate_speed * delta)
	$AnimationPlayer.play("breathing")
	shoot()
	if current_hp <= max_hp/2:
		rotate_dir = 1
		rotate_speed += .1
	if (current_hp <= 0):
		die()

func spawn_bullet(bullet_path, marker):
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	bullet.position = marker.global_position
	bullet.rotation = marker.global_rotation

func shoot():
	if can_shoot:
		spawn_bullet(BulletPath,$Rotator/Gun1/ShootPos)
		spawn_bullet(BulletPath,$Rotator/Gun2/ShootPos)
		spawn_bullet(BulletPath,$Rotator/Gun3/ShootPos)
		spawn_bullet(BulletPath,$Rotator/Gun4/ShootPos)
		
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()

func take_damage(damage):
	current_hp -= damage

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
