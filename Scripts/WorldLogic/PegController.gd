extends PinJoint2D

export var explode_time = 4
export var blink_time = 0.5;
export (Color) var blink_color;

var player = null;
var explode_timer;
var blink_timer; 
var blink_on = false;

func _ready():
	
	explode_timer = Timer.new()
	add_child(explode_timer);
	explode_timer.autostart = false
	
	blink_timer = Timer.new()
	add_child(blink_timer);
	blink_timer.autostart = false
	
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")
	explode_timer.connect("timeout", self, "_on_explode_timer_timeout")
	blink_timer.connect("timeout", self, "_on_blink_timer_timeout")
	
	


func _on_body_entered(body):
	
	explode_timer.start(explode_time)
	blink_timer.start(blink_time)
	
	if ("Player" in body.name) :
		if(!body.is_hanging):
			player = body;
			body.next_peg = self;
			body.linear_velocity = Vector2.ZERO


func distance(player_position):
	return (player_position - global_position).length()
	

func _on_body_exited(body):
	if ("Player" in body.name):
		explode_timer.stop()
		blink_timer.stop()
		get_node("Peg").modulate = Color.white
		player = null;
		

func _on_explode_timer_timeout():
	player.get_node("HandsSprite").frame = 0;
	player.get_node("HandsSprite").position.x = 129.514
	player.get_node("HandsSprite").visible = false;
	player.get_node("Head/HeadSprite").frame = 0;
	player.is_hanging = false;
	self.queue_free();

func _on_blink_timer_timeout():
	if (blink_on):
		get_node("Peg").modulate = Color.white
		blink_on = false
	else:
		get_node("Peg").modulate = blink_color;
		blink_on = true
		
