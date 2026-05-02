extends StaticBody3D

@export var dispenses_item: String = "RawMeat"
var item_scene = preload("res://scenes/Item.tscn")

func interact(player):
	if player.held_item == null:
		player.give_item(item_scene, dispenses_item)
