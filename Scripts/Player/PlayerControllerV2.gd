extends RigidBody2D

var is_hanging = false;

var body_pressed = false;

var impulse_vector;

var next_peg = null;

var current_peg = null;

var closest_peg = null;

export var impulse_multiplier = 8;
export var seek_multiplyer = 500;
export var catch_effect_intesety = 200



# Called when the node enters the scene tree for the first time.
func _ready():
	$Head/HeadSprite/BodyTouchable.connect("pressed", self, "_on_body_pressed");
	$Head/HeadSprite/BodyTouchable.connect("released", self, "_on_body_released");
	$Head.connect("body_entered", self, "_on_head_body_entered");


func _physics_process(delta):
	if (is_hanging and body_pressed):
		impulse_vector = global_position - get_global_mouse_position();
		headMovement();
	elif(!is_hanging and !next_peg):
		OrientCatch()

	if(next_peg):
		catchPeg(delta);


func OrientCatch():
	for peg in get_tree().get_nodes_in_group("nearby_pegs"):
		if (!closest_peg):
			closest_peg = peg
		if (closest_peg.distance(global_position) > peg.distance(global_position)):
			closest_peg = peg;
		look_at(closest_peg.position)



func catchPeg(delta):

	if (next_peg):
		var offset = (position - $HandsSwingPos.global_position) ;
		look_at(next_peg.position);
		
		linear_velocity = ((next_peg.position + offset ) - (position)) * seek_multiplyer * delta;
		
		print(($HandsSwingPos.global_position - next_peg.position).length())
		if (($HandsSwingPos.global_position - next_peg.position).length() < 20):
			look_at(next_peg.position);
			next_peg.node_a = self.get_path();
			$HandsSprite.visible = true;
			current_peg = next_peg;
			closest_peg = current_peg
			next_peg = null;
			is_hanging = true;
			$Head.apply_central_impulse(Vector2(randi() % catch_effect_intesety + 100, randi() % catch_effect_intesety + 100))
			print("catch");


func headMovement():
	$Head.apply_central_impulse((get_global_mouse_position() - $Head.global_position) * 8)
	$Head/HeadCollider.disabled = true;
	animateStretch();

func animateStretch():
	
	if (impulse_vector.length() < 300):
		$Head/HeadSprite.frame = 1;
		$HandsSprite.frame = 0;
		$HandsSprite.position.x = 129;

	elif (impulse_vector.length() < 500):
		
		$Head/HeadSprite.frame = 2;
		
		$HandsSprite.frame = 1;
		$HandsSprite.position.x = 111;

	elif (impulse_vector.length() < 700):

		$Head/HeadSprite.frame = 3;
		
		$HandsSprite.frame = 2;
		$HandsSprite.position.x = 100;


	elif (impulse_vector.length() < 10000):
		
		$Head/HeadSprite.frame = 4;
		
		$HandsSprite.frame = 3;
		$HandsSprite.position.x = 68;

	
	

func _on_body_pressed():
	body_pressed = true;

func _on_body_released():
	body_pressed = false;
	
	if (is_hanging and impulse_vector.length() > 500):
		if (current_peg):
			current_peg.node_a = "";
		apply_central_impulse(impulse_vector * impulse_multiplier);
		$HandsSprite.frame = 0;
		$HandsSprite.position.x = 129.514
		$Head/HeadSprite.frame = 0;
		$HandsSprite.visible = false;
		is_hanging = false;
		

func _on_head_body_entered(body):
	print("head" + body);


