extends Camera2D


export (NodePath) var player_path;
export var camera_offset = 400;
export var horizontal_helper = 200;

var camera_speed = 2;
var player;
var highest = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path);
	highest = player.position.y

func _process(delta):
	
	
	if (player.position.y < highest):
		highest = player.position.y
	
	if (position.y > highest + camera_offset and !player.is_hanging):
		print("lower")
		position.y = lerp(position.y, highest + camera_offset, camera_speed * delta);
	else:
		position.y = lerp(position.y, player.position.y - camera_offset, camera_speed * delta);
		if(player.is_hanging):
			if (player.position.x > OS.get_real_window_size().x - 200 or player.position.x < 200):
				position.x = lerp(position.x, player.position.x, camera_speed * delta);
			else:
				position.x = lerp(position.x, OS.get_real_window_size().x / 2, camera_speed * delta);
		else:
			position.x = lerp(position.x, OS.get_real_window_size().x / 2, camera_speed * delta);
			

