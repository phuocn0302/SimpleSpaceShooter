extends Area2D

var ExplosionPath = preload("res://Scenes/explosion.tscn")
var BulletPath = preload("res://Scenes/enemy_bullet.tscn")

var contact_damage: int = 1
var can_shoot: bool = true

@export var hp:int = 20

@onready var player = get_parent().get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Rotator.rotate(-1 * delta)
	shoot()
	if (hp <= 0):
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
		await get_tree().create_timer(0.2).timeout
		can_shoot = true

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()

func take_damage(damage):
	hp -= damage

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
