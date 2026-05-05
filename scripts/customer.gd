extends CharacterBody3D

signal order_completed(cust)
signal reached_counter
signal customer_left(cust)
signal order_placed(cust)

@onready var nav = $NavigationAgent3D
var target_pos: Vector3

var current_state = "moving"
var order_recipe: Dictionary
var desired_order = "Burger"
var order_type = "takeaway"
var target_table: Node3D = null
var eat_timer = 10.0

var patience = 60.0
var max_patience = 60.0
var has_ordered = false
var order_label: Label3D

func _ready():
	order_recipe = RecipeManager.get_random_recipe()
	desired_order = order_recipe.result
	order_type = "takeaway" if randf() > 0.5 else "dine_in"
	_create_order_label()
	order_label.visible = false

func _create_order_label():
	order_label = Label3D.new()
	order_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	order_label.text = "[" + order_type.to_upper() + "]\n" + order_recipe.name + "\n("
	
	var ingredients_counts = {}
	for ing in order_recipe.ingredients:
		if ingredients_counts.has(ing):
			ingredients_counts[ing] += 1
		else:
			ingredients_counts[ing] = 1
	
	var parts = []
	for ing in ingredients_counts.keys():
		var count = ingredients_counts[ing]
		if count > 1:
			parts.append(str(count) + "x " + ing)
		else:
			parts.append(ing)
	
	order_label.text += " + ".join(parts) + ")"
	order_label.pixel_size = 0.005
	order_label.position.y = 2.0
	order_label.font_size = 32
	add_child(order_label)

func set_target(pos: Vector3):
	if current_state != "leaving":
		nav.target_position = pos
		target_pos = pos
		current_state = "moving"

func _physics_process(delta):
	if current_state == "moving":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.5:
			current_state = "waiting"
			reached_counter.emit()
			velocity = Vector3.ZERO
		move_and_slide()
	elif current_state == "waiting":
		patience -= delta
		if patience <= 0:
			customer_left.emit(self)
			leave_store()
	elif current_state == "moving_to_table":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.5:
			current_state = "eating"
			eat_timer = 10.0
			velocity = Vector3.ZERO
		move_and_slide()
	elif current_state == "eating":
		eat_timer -= delta
		if eat_timer <= 0:
			if target_table:
				target_table.free_table()
			leave_store()
	elif current_state == "leaving":
		var next_pos = nav.get_next_path_position()
		var dir = global_position.direction_to(next_pos)
		velocity = dir * 3.0
		if global_position.distance_to(target_pos) < 1.0:
			queue_free()
		move_and_slide()

func interact(player):
	if current_state == "waiting":
		if not has_ordered and player.held_item == null:
			has_ordered = true
			order_label.visible = true
			order_placed.emit(self)
			current_state = "moving"
		elif has_ordered and player.held_item != null and player.held_item.item_id == desired_order:
			player.take_item()
			order_completed.emit(self)
			if order_type == "takeaway":
				leave_store()
			else:
				go_to_table()

func go_to_table():
	var tables = get_tree().get_nodes_in_group("tables")
	var found_table = null
	for t in tables:
		if not t.occupied:
			found_table = t
			break
	
	if found_table != null:
		found_table.occupy()
		target_table = found_table
		current_state = "moving_to_table"
		nav.target_position = found_table.global_position
		target_pos = found_table.global_position
	else:
		leave_store()

func leave_store():
	current_state = "leaving"
	nav.target_position = Vector3(10, 0, 10)
	target_pos = nav.target_position
