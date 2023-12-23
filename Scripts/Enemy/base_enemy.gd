extends Node2D
class_name BaseEnemy

var stat: BaseEnemyResource

var move_dir: Vector2 = Vector2.LEFT
var time: float = 0
var player: Player


func straight_move():
	move_dir = move_dir.normalized()
	self.global_position += stat.speed * move_dir * get_process_delta_time()

func sine_move(interval: float = 5):
	move_dir = move_dir.normalized()
	time = fposmod(time + get_process_delta_time(), 2 * PI)
	self.global_position += stat.speed * move_dir * get_process_delta_time()
	self.global_position.y += sin(time * interval) 

func follow_player(active: bool):
	player = Global.player
	if player and active:
		move_dir = self.global_position.direction_to(player.global_position)
	else:
		move_dir = Vector2.LEFT
