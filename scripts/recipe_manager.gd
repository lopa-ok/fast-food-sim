extends Node

var recipes = []

func _ready():
	recipes.append({
		"name": "Burger",
		"ingredients": ["Bun", "CookedMeat"],
		"result": "Burger"
	})
	
	recipes.append({
		"name": "Double Burger",
		"ingredients": ["Bun", "CookedMeat", "CookedMeat"],
		"result": "DoubleBurger"
	})
	
	recipes.append({
		"name": "French Fries",
		"ingredients": ["Fries"],
		"result": "Fries"
	})
	
	recipes.append({
		"name": "Burger and Fries",
		"ingredients": ["Bun", "CookedMeat", "Fries"],
		"result": "DoubleBurger"
	})

func get_random_recipe() -> Dictionary:
	return recipes[randi() % recipes.size()]

func check_recipe(ingredients_list: Array) -> String:
	var sorted_input = []
	for item in ingredients_list:
		if typeof(item) == TYPE_STRING:
			sorted_input.append(item)
	sorted_input.sort()
	
	for recipe in recipes:
		var recipe_ingredients = []
		for item in recipe.ingredients:
			if typeof(item) == TYPE_STRING:
				recipe_ingredients.append(item)
		recipe_ingredients.sort()
		
		if sorted_input.size() == recipe_ingredients.size():
			var is_match = true
			for i in range(sorted_input.size()):
				if sorted_input[i] != recipe_ingredients[i]:
					is_match = false
					break
			
			if is_match:
				return recipe.result
	return ""
