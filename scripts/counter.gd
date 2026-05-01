extends StaticBody3D


var item_scene = preload("res://scenes/Item.tscn")


func interact(player):
	if player.held_item == null:
		player.give_item(item_scene, "RawBurger")
