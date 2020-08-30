extends Node2D

var RegularPeg = preload("res://Scenes/RegularPeg.tscn")
var SpikePeg = preload("res://Scenes/SpikePeg.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text" 5,363.129
export (Array, NodePath) var foregrounds_paths;

var foregrounds;

var player;

var score = 0;

var player_start;

var foregroundsize;



# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Camera2D/UI/CenterContainer/Panel/VBoxContainer/Restart.connect("button_down", self, "_on_restart_button_down")
	
	foregrounds = Array();
	player = $Player
	
	player_start = player.position 
	
	randomize();
	
	for foreground in foregrounds_paths:
		foregrounds.append(get_node(foreground));
		
	foregroundsize = foregrounds[0].get_node("SideWall_11").texture.get_size().y
	print(foregroundsize)
	
	generatePegs()



func _process(delta):
	HollywoodMagic()
	
	if score < (player_start - player.position).length():
		score = (player_start - player.position).length();
	if !player.get_node("VisibilityNotifier2D").is_on_screen():
		$Camera2D/UI.show();
		$Camera2D/UI/CenterContainer/Panel/VBoxContainer/Score.text = "Score: " + String(score);
		get_tree().paused = true;
		player.queue_free();
		
		
		
	
	
func HollywoodMagic():
	if (player.position.y < foregrounds[0].position.y + foregroundsize):
		
		var poped = foregrounds.pop_back();
		
		var pegs = get_tree().get_nodes_in_group("nearby_pegs");
		
		for peg in pegs:
			if (peg.position.y > poped.position.y):
				peg.queue_free()
		
		poped.position.y = foregrounds[0].position.y - 2680.113
		foregrounds.push_front(poped);
		
		generatePegs();
		


func generatePegs():
	var max_height = foregrounds[0].position.y
	
	var peg_amount =  randi() % 4 + 3;
	
	var next_peg_position = 2700
	
	for i in range(peg_amount):
		
		var peg_type = randi() % 9;
		
		if (peg_type < 7):
			var new_peg = RegularPeg.instance();
			add_child(new_peg);
			new_peg.position.y = max_height + next_peg_position
			new_peg.position.x = rand_range(50, OS.get_real_window_size().x -200);
			next_peg_position -= 2700 / peg_amount;
		if (peg_type > 7):
			var new_peg = SpikePeg.instance();
			add_child(new_peg);
			new_peg.position.y = max_height + next_peg_position
			new_peg.position.x = rand_range(50, OS.get_real_window_size().x -200);
			next_peg_position -= 2700 / peg_amount;
			
	
func _on_restart_button_down():
	get_tree().paused = false;
	get_tree().reload_current_scene()
