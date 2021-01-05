extends Sprite


var alive = true
var grid_pos_x = 0
var grid_pos_y = 0 


# Called when the node enters the scene tree for the first time.
func _ready():
	alive = false
	modulate = Color(0.2,0.2,0.2,1)
	add_to_group("sprites")
	



func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("left_mouse") and Input.is_action_pressed("control_key"):
		alive = true
		modulate = Color(0,1,0,1)
		get_parent().alive_or_dead[grid_pos_x][grid_pos_y] = 1
	if Input.is_action_pressed("left_mouse") and Input.is_action_pressed("shift_key"):
		alive = false
		modulate = Color(0.2, 0.2, 0.2, 1)
		get_parent().alive_or_dead[grid_pos_x][grid_pos_y] = 0
