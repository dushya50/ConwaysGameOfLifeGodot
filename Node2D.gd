extends Node2D

onready var cam = $Camera2D
onready var btn = $CanvasLayer/Button
onready var grid_size_btn = $CanvasLayer/OptionButton
var sprt = preload("res://Sprite.tscn")
var grid_size = 10
var grid_sizes = [10, 20, 30, 40]
var snap_val = 64
var alive_or_dead = []
var sprites = []
var sprt_new
var rng = RandomNumberGenerator.new()
var wait_time = 0.2
var zoom = Vector2(1,1)
var start_sim = false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	for i in range(grid_sizes.size()):
		grid_size_btn.add_item(str(grid_sizes[i]))
	grid_size_btn.selected = 0
	# show the sprites 
	set_up_grid()
	

func set_up_grid():
	remove_old_grid()
	var matrix = []
	var sprt_matrix = []
	for i in range(grid_size+2):
		matrix.append([])
		if i>=1 and i<= grid_size:
			sprt_matrix.append([])
		for j in range(grid_size+2):
			matrix[i].append(0)
			if i>=1 and i<= grid_size and j>=1 and j<=grid_size:
				sprt_new = sprt.instance()
				sprt_new.position = Vector2((i+1)*snap_val,(j+1)*snap_val)
				sprt_new.grid_pos_x = i
				sprt_new.grid_pos_y = j
				sprt_matrix[i-1].append(sprt_new)
				#mouse_pos_snapped = get_global_mouse_position().snapped(Vector2(snap_val, snap_val))
				add_child(sprt_new)
	alive_or_dead = matrix
	sprites = sprt_matrix
	
func remove_old_grid():
	var sprites_list = get_tree().get_nodes_in_group("sprites")
	for item in sprites_list:
		remove_child(item)
		item.queue_free()

	

func _input(event):
	if Input.is_action_pressed("move_cam") and event is InputEventMouseMotion:
		cam.global_position -= event.relative
	if Input.is_action_just_released("zoom_in"):
		zoom -= Vector2(0.1,0.1)
		zoom.x = max(zoom.x, 0.1)
		zoom.y = max(zoom.y, 0.1)
	if Input.is_action_just_released("zoom_out"):
		zoom +=Vector2(0.1, 0.1)
	cam.set_zoom(zoom)
	
	if Input.is_action_pressed("left_mouse") and Input.is_action_pressed("control_key"):
		start_sim = false
		btn.text = "Start"
		set_process(false)
	if Input.is_action_pressed("left_mouse") and Input.is_action_pressed("shift_key"):
		start_sim = false
		btn.text = "Start"
		set_process(false)


#
func _process(delta):
	update_the_state()
	set_process(false)
	yield(get_tree().create_timer(wait_time), "timeout") 
	set_process(true)
														 
		
		
		#yield(self, "finished")


func update_the_state():
	if start_sim:
		var old_state = alive_or_dead.duplicate(true)
		for i in range(1, grid_size+1):
			for j in range(1, grid_size+1):
				var sum = get_neighbors_sum(old_state, i, j)
				if old_state[i][j]==0 and sum == 3:
					alive_or_dead[i][j]=1
					sprites[i-1][j-1].alive = true
					sprites[i-1][j-1].modulate = Color(0,1,0,1)
				if old_state[i][j]==1 and sum != 2 and sum !=3:
					alive_or_dead[i][j]=0
					sprites[i-1][j-1].alive = false
					sprites[i-1][j-1].modulate = Color(0.2,0.2,0.2,1)

	#yield(get_tree().create_timer(wait_time), "timeout")
			
func get_neighbors_sum(old_state, i, j):
	var sum = 0 
	for a in [-1, 0, 1]:
		for b in [-1, 0, 1]:
			sum+=old_state[i+a][j+b]
	sum -= old_state[i][j]
	return sum
	

#
func _on_Button_pressed():
	if not start_sim:
		start_sim = true
		btn.text = "Stop"
		set_process(true)
	else:
		start_sim = false
		btn.text = "Start"
		set_process(false)





func _on_OptionButton_item_selected(index):
	grid_size = grid_sizes[index]
	set_up_grid()
