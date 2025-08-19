extends Control
var Duck_ID

signal duck_selected
@onready var Show = $Info_display.visible

#Sets the duck that is displayed in it to load the accessories of the ID it is given
func render_display(ID):
	Duck_ID = ID
	$Duck_Base.load_duck(ID)


#Shows the plate above to change to wardrobe
func display_duck_info():
	if Show == false:
		$Info_display.visible = true
		Show = true
	elif Show == true:
		$Info_display.visible = false
		Show = false

#Changes scene to the wardrobe with the duck that is displayed loaded
func _on_wardrobe_button_pressed():
	#Tells the wardrobe which duck to load
	emit_signal("duck_selected_collection", Duck_ID)
	get_tree().change_scene_to_file("res://Game/game_wardrobe_scene.tscn")
	Globals.displaying_duck_ID = Duck_ID
	Globals.game_last_scene = "wardrobe"
	Globals.current_scene = "game_wardrobe"


#Toggles duck info on click
func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		display_duck_info()
