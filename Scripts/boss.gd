extends Area2D

var ExplosionPath = preload("res://Scenes/explosion.tscn")
var BulletPath = preload("res://Scenes/enemy_bullet.tscn")

var contact_damage: int = 1
var can_shoot: bool = true

@export var hp: int = 200
@export var fire_rate: float = 0.3

@onready var player = get_tree().current_scene.get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shoot()
	if (hp <= 0):
		die()

func spawn_normal_bullet(bullet_path, marker):
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	bullet.position = marker.global_position

func spawn_chasing_bullet(bullet_path, marker):
	if get_parent().get_parent().has_node("Player"):
		var bullet = bullet_path.instantiate()
		get_parent().add_child(bullet)


func shoot():
	if can_shoot:
		spawn_normal_bullet(BulletPath, $MainGun)
		spawn_normal_bullet(BulletPath, $SubGun1/SubGunPos1)
		spawn_normal_bullet(BulletPath, $SubGun1/SubGunPos2)
		spawn_normal_bullet(BulletPath, $SubGun2/SubGunPos1)
		spawn_normal_bullet(BulletPath, $SubGun2/SubGunPos2)
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
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
