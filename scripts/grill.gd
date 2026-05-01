extends StaticBody3D

var item_scene = preload("res://scenes/Item.tscn")


var has_burger: bool = false
var is_cooked: bool = false
var cook_timer: float = 0.0
var cook_time: float = 3.0


@onready var visual = $Visual


func update_color(color: Color):
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	visual.set_surface_override_material(0, mat)



func _process(delta):
	if has_burger and not is_cooked:
		cook_timer += delta
		if cook_timer >= cook_time:
			is_cooked = true
			update_color(Color(0.4, 0.2, 0.0))


func interact(player):
	if not has_burger and player.held_item != null and player.held_item.item_name == "RawBurger":
		player.take_item()
		has_burger = true
		is_cooked = false
		cook_timer = 0.0
		visual.visible = true
		update_color(Color(0.8, 0.2, 0.2))
		print("Started cooking")
	elif has_burger and is_cooked and player.held_item == null:
		player.give_item(item_scene, "CookedBurger")
		has_burger = false
		visual.visible = false
		print("Took cooked burger")
		
	
		
