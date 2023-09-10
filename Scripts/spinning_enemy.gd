extends Area2D

var ExplosionPath = preload("res://Scenes/Particles/explosion.tscn")
var BulletPath = preload("res://Scenes/enemy_bullet.tscn")

@export var fire_rate: float = 0.1
@export var rotate_speed: float = 2


var contact_damage: int = 1
var can_shoot: bool = true
var rotate_dir: int  = -1

var player = null

func _process(delta):
	$Rotator.rotate(rotate_dir * rotate_speed * delta)
	$AnimationPlayer.play("breathing")
	shoot()

func spawn_bullet(bullet_path, marker):
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	bullet.transform_mode()
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

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
