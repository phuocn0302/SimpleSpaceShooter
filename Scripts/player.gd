class_name Player
extends CharacterBody2D

var BulletPath = preload("res://Scenes/bullet.tscn")
var ExplosionPath = preload("res://Scenes/explosion.tscn")

@export var speed: float = 200.0
@export var fire_rate: float = 0.1 # Per second
@export var hp: int = 3

var iframe_timer: float = 0.6
var can_shoot = true
var can_take_damage = true
var can_deal_contact_damage = true

@onready var anim_player = $AnimationPlayer
@onready var normal_shoot_pos = $NormalShootPos/ShootSpot

func _ready():
	anim_player.play("spawn")
	iframe()


func _process(delta):
	$AnimatedSprite2D.play("default")
	if (Input.is_action_pressed("ui_accept")):
		shoot()
	if (hp <=0):
		die()

func _physics_process(delta):
	var dir = Input.get_vector("ui_left","ui_right","ui_up","ui_down").normalized()
	velocity = dir * speed * delta * 60
	move_and_slide()

func shoot():
	if can_shoot:
		var bullet = BulletPath.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = normal_shoot_pos.global_position
		can_shoot = false
		await get_tree().create_timer(fire_rate).timeout
		can_shoot = true

func iframe():
	can_take_damage = false
	can_deal_contact_damage = false
	await get_tree().create_timer(iframe_timer).timeout
	anim_player.play("RESET")
	can_take_damage = true
	can_deal_contact_damage = true

func take_damage(damage):
	if can_take_damage:
		hp -= damage
		anim_player.play("hit")
		iframe()

func die():
	var explosion = ExplosionPath.instantiate()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()

func _on_hitbox_area_entered(area):
	if (can_deal_contact_damage) and (area.is_in_group("Enemy")):
		area.die()
		take_damage(1)
