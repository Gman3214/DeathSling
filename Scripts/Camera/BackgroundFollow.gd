extends Node2D


export (NodePath) var camera_path;

export var follow_speed = 5

var camera


# Called when the node enters the scene tree for the first time.
func _ready():
	camera = get_node(camera_path);


func _process(delta):
	position.y = lerp(position.y, camera.position.y, follow_speed * delta);
