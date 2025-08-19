extends Node
const ENCRYPTION_KEY = "secretsecretencryptionducksbread"
var current_save_data = {}
var default_save_data = {
		"username": "",
		"timer_Mode_Prefernce": "Normal",
		"Last_Timer_Length":"3300",
		"Last_Break_Length":"300",
		"ducks":[
			
		],
		"goals":[
			
		],
		"money":500,
		"food":2000,
		"items_owned":[
			
		]
	}
#Directory of save filess
var saves_dir = DirAccess.open("user://saves")
var save_file = ""
var invalid_characters_username = ['"',"'", "\"","\n","[","]","{","}"]
var invalid_characters_other = ['"',"'", "\"","[","]","{","}"]

func _ready():
	#Creates save directory if needed
	DirAccess.open("user://").make_dir_recursive("user://saves")

#Updates current save data to be the defualt and saves a new file with this data named "username".save
func new_save(username):
	current_save_data = default_save_data.duplicate(true)
	print(current_save_data)
	current_save_data["username"] = username
	save_file = username + ".save"
	save_game()

#Save global variables then write with encryption to the save file of the current save dataa
func save_game():
	Globals.save_global_data()
	var file = FileAccess.open_encrypted_with_pass("user://saves/"+save_file, FileAccess.WRITE, ENCRYPTION_KEY)
	file.store_string(JSON.stringify(current_save_data))
	file.close()
	print("\nNew game saved.", current_save_data)


#Finds the current users save file and writes over their data setting it to the default save data
func reset_data():
	if FileAccess.file_exists("user://saves/"+save_file):
		var file = FileAccess.open_encrypted_with_pass("user://saves/"+save_file, FileAccess.WRITE, ENCRYPTION_KEY)
		file.store_string(JSON.stringify(default_save_data))
		print("\n\nDEFAULT USER SAVE DATA" + str(default_save_data))
		file.close()
		var username = current_save_data["username"] 
		print("\n" + username)
		current_save_data = default_save_data.duplicate(true)
		print("\n\nDEFAULT USER SAVE DATA" + str(default_save_data))
		print("\n\nCURRENT USER SAVE DATA" + str(current_save_data))
		current_save_data["username"] = username
		print("Data Reset")
		print(current_save_data)
	else:
		print("No save found.")

#ABSOLUTELY Deletes their save file
func delete_data():
	DirAccess.remove_absolute("user://saves/"+save_file)

#Searches for users save files, reads and decrypts and sets the current save data to be their save data that was read
func load_game():
	var file = FileAccess.open_encrypted_with_pass("user://saves/"+save_file, FileAccess.READ, ENCRYPTION_KEY)
	var content = file.get_as_text()
	file.close()
	current_save_data = JSON.parse_string(content)
	Globals.load_save_data()
	print("Game loaded:", current_save_data)

#Searches for save files with matching usernames and returns true if login successful, setting the save file to the file found
func login(username):
	saves_dir = DirAccess.open("user://saves")
	saves_dir.list_dir_begin()
	var file = saves_dir.get_next()
	while file != "":
		var searching_file = FileAccess.open_encrypted_with_pass("user://saves/"+file, FileAccess.READ, ENCRYPTION_KEY)
		var content = JSON.parse_string(searching_file.get_as_text())
		searching_file.close()
		if content["username"] == username:
			save_file = file
			return true
		file = saves_dir.get_next()
	saves_dir.list_dir_end()
	#No user found
	return false

#Searches to check if a save file with the same username given is found. If noot creates a new save with username inputted
func create_user(username):
	saves_dir = DirAccess.open("user://saves")
	saves_dir.list_dir_begin()
	var file = saves_dir.get_next()
	while file != "":
		var searching_file = FileAccess.open_encrypted_with_pass("user://saves/"+file, FileAccess.READ, ENCRYPTION_KEY)
		var content = JSON.parse_string(searching_file.get_as_text())
		searching_file.close()
		if content["username"] == username:
			print("User: ", username, "already taken")
			return false
		file = saves_dir.get_next()
	saves_dir.list_dir_end()
	#Username Valid
	new_save(username)
	return true

#Saves game and user data THEN resets data to be fresh and returns to login screen
func sign_out():
	save_game()
	current_save_data = default_save_data.duplicate(true)
	print("\n\nRESET DATA")
	print(current_save_data)
	get_tree().change_scene_to_file("res://Login/login_scene.tscn")
	print("Signed out")

#Santisies data
#Return false means bad input
func filter_input_username(type,input):
	#Filters for specific type of input
	if type == "username":
		#Use seperate variables to check if any replacements were made and determine if return false
		var input_before = input
		if input.length() < 1 or input.length() > 20:
			print("Invalid username")
			return false
		for i in invalid_characters_username:
			input = input.replace(i, " ")
			if input_before != input:
				print("Invalid Characters")
				return false
		
	if type == "other":
		#Use seperate variables to check if any replacements were made and determine if return false
		var input_before = input
		for i in invalid_characters_other:
			input = input.replace(i, " ")
			if input_before != input:
				print("Invalid Characters")
				return false
		if input.length() > 100:
			print("Invalid input")
			return false
