extends StaticBody3D


var occupied: bool = false


func occupy():
	occupied = true

func free_table():
	occupied = false
