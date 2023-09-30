extends Resource
class_name LaserResource

@export var laser_texture: Texture2D

@export var velocity: Vector2 = Vector2.LEFT
@export var distance: float = 360

## Ignore if using texture
@export var laser_width: int

@export var laser_cast_time: float = 0.1
@export var laser_decay_time: float = 0.2
@export var laser_dur: float = 0.25
