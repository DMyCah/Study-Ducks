extends Control

@onready var Goal_Input = $VBoxContainer/Goal_Input
@onready var target_hours = $VBoxContainer/Target_Hours_Input
var goal_resource = preload("res://Game/Goals/goal.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#Stretches Create Panel so there is no otherflow out of the boundaries
	self.size.y = $VBoxContainer.size.y + 70

#Sets Default Values
var target = 3600
var goal = "Goal"
var goals = []


func _on_goal_input_text_changed():
	#Ensure top line displayed after pressing enter
	var line = Goal_Input.get_caret_line()-1
	Goal_Input.scroll_vertical = line
	#Dynamically adjust size of text edit
	if Goal_Input.custom_minimum_size.y < 100:
		Goal_Input.custom_minimum_size.y = Goal_Input.get_line_count() * Goal_Input.get_line_height() + 4
	if Goal_Input.custom_minimum_size.y > Goal_Input.get_line_count() * Goal_Input.get_line_height() + 4:
		Goal_Input.size.y = Goal_Input.get_line_count() * Goal_Input.get_line_height() + 4
	goal = Goal_Input.text

#Updates target value of hours to seconds
func _on_target_hours_input_text_changed(new_text):
	target = float(new_text)*3600

#Creates a goal object within goal_container to be displayed
func _on_submit_pressed():
	#Sanitisation
	var sanitise = SaveManager.filter_input_username("other",goal)
	if sanitise == false:
		$"../Filter_Detection".detection("INPUT")
	else:
		#Creates goal object
		var goal_instance = goal_resource.instantiate()
		#Creates goal save
		goal_instance.create_goal(goal, target)
		get_parent().get_node("ScrollContainer/Goal_Container").add_child(goal_instance)
		goals.append(goal_instance)
		get_parent().instantiate_goals()

