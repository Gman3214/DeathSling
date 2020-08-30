extends RigidBody2D

var is_hanging = true;

var body_pressed = false;

var impluse_vector;

export (NodePath) var peg;

export var impulse_multiplier = 5



# Called when the node enters the scene tree for the first time.
func _ready():
	$Body/BodyTouchable.connect("pressed", self, "_on_body_pressed");
	$Body/BodyTouchable.connect("released", self, "_on_body_released");
	

func _process(delta):
	
	if (is_hanging and body_pressed):
		movement(delta);
	elif(is_hanging):
		pass
		#resetBody(delta)
	else:
		pass
	

func movement(delta):
	print(OS.get_real_window_size())
	var invertedx = OS.get_real_window_size().x + (global_position.x - get_global_mouse_position().x)
	var invertedy = OS.get_real_window_size().y + (global_position.y - get_global_mouse_position().y)
	
	var mouse_vector = get_global_mouse_position() - global_position;
	
	var inverted_mouse = global_position - mouse_vector;
	
	impluse_vector = global_position - get_global_mouse_position();
	
	look_at(inverted_mouse);
	
	animateStretch(delta);

func resetBody(delta):
		$Body.position.x = lerp($Body.position.x, -198, delta * 7)
		$Body.frame = 0
		
		$Hands.frame = 0
		$Hands.position.x = -82


func animateStretch(delta):
	
	if (impluse_vector.length() < 300):
		
		$Body.position.x = lerp($Body.position.x, 13, delta * 7)
		$Body.frame = 1
		
		$Hands.frame = 0
		$Hands.position.x = 129
		
	elif (impluse_vector.length() < 500):
		
		$Body.position.x = lerp($Body.position.x, -10, delta * 7)
		$Body.frame = 2
		
		$Hands.frame = 1
		$Hands.position.x = 111
		
		print("1")
		
	elif (impluse_vector.length() < 700):
		
		$Body.position.x = lerp($Body.position.x, -70, delta * 7)
		$Body.frame = 3
		
		$Hands.frame = 2
		$Hands.position.x = 100
		
		print("2")
		
	elif (impluse_vector.length() < 10000):
		
		$Body.position.x = lerp($Body.position.x, -120, delta * 7)
		$Body.frame = 4
		
		$Hands.frame = 3
		$Hands.position.x = 68
		
		print("3")
	
	

func _on_body_pressed():
	body_pressed = true;

func _on_body_released():
	body_pressed = false;
	
	if (is_hanging and impluse_vector.length() > 500):
		get_node(peg).node_a = ""
		apply_central_impulse(impluse_vector.normalized() * impluse_vector.length() * impulse_multiplier);
		is_hanging = false
		



