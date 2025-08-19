extends CharacterBody2D

#References list of ducks in save data
var duck_dictionary = SaveManager.current_save_data["ducks"]

#instances all variables
var ID = 1
var Body
var Headwear
var Eyewear
var Neckwear
var FullBodywear
var Wingwear
var Footwear
var Name
var Experience
var Level


#Changes the texture on each individual part based on the path for the png given and which part to change
func change_accessory(type, new_accessory_path):
	if type == "Headwear/":
		if new_accessory_path == "clear":
			$Headwear.texture = null
			Headwear = null
		else:
			$Headwear.texture = load(new_accessory_path)
			Headwear = new_accessory_path
	elif type == 'Eyewear/':
		if new_accessory_path == "clear":
			$Eyewear.texture = null
			Eyewear = null
		else:
			$Eyewear.texture = load(new_accessory_path)
			Eyewear = new_accessory_path
	elif type == 'Neckwear/':
		if new_accessory_path == "clear":
			$Neckwear.texture = null
			Neckwear = null
		else:
			$Neckwear.texture = load(new_accessory_path)
			Neckwear = new_accessory_path
	elif type == 'Footwear/':
		if new_accessory_path == "clear":
			$Footwear.texture = null
			Footwear = null
		else:
			$Footwear.texture = load(new_accessory_path)
			Footwear = new_accessory_path
	elif type == 'Wingwear/':
		if new_accessory_path == "clear":
			$Wingwear.texture = null
			Wingwear = null
		else:
			$Wingwear.texture = load(new_accessory_path)
			Wingwear = new_accessory_path
	elif type == 'FullBodywear/':
		if new_accessory_path == "clear":
			$FullBodywear.texture = null
			FullBodywear = null
		else:
			$FullBodywear.texture = load(new_accessory_path)
			FullBodywear = new_accessory_path


func load_duck(Loading_ID):
	ID = Loading_ID
	#Takes the ID of the duck and sets loading to the duck object found with the index
	var loading = duck_dictionary[find_duck_Index_with_ID(Loading_ID)]
	if loading["Body"]:
		Body = loading["Body"]
		$Body.texture = load(Body)
	else:
		print("Error loading body for duck: " + ID)
	#If the loading duck has a value, then render the accessory
	if loading["Headwear"]:
		#Sets headwear to the path of the accessories image
		Headwear = loading["Headwear"]
		$Headwear.texture = load(Headwear)
	else:
		$Headwear.texture = null
		Headwear = null

	if loading["Eyewear"]:
		Eyewear = loading["Eyewear"]
		$Eyewear.texture = load(Eyewear)
	else:
		$Eyewear.texture = null
		Eyewear = null

	if loading["Neckwear"]:
		Neckwear = loading["Neckwear"]
		$Neckwear.texture = load(Neckwear)
	else:
		$Neckwear.texture = null
		Neckwear = null

	if loading["FullBodywear"]:
		FullBodywear = loading["FullBodywear"]
		$FullBodywear.texture = load(FullBodywear)
	else:
		$FullBodywear.texture = null
		FullBodywear = null

	if loading["Wingwear"]:
		Wingwear = loading["Wingwear"]
		$Wingwear.texture = load(Wingwear)
	else:
		$Wingwear.texture = null
		Wingwear = null

	if loading["Footwear"]:
		Footwear = loading["Footwear"]
		$Footwear.texture = load(Footwear)
	else:
		$Footwear.texture = null
		Footwear = null

	Name = loading["Name"]



#Returns ducks data in dictionary format
func get_duck_data():
	return {
		"ID": ID,
		"Name": Name,
		"Body": Body,
		"Headwear": Headwear,
		"Eyewear": Eyewear,
		"Neckwear": Neckwear,
		"FullBodywear": FullBodywear,
		"Wingwear": Wingwear,
		"Footwear": Footwear,
		"Experience": Experience,
		"Level": Level
	}


#Create a NEW duck save, setting ID if there is already ducks made, if not ID defaulted to 1
#As any duck created will be created  with "set_data()" at ready() and then checked here
func create_duck_save():
	generate_duck()
	if duck_dictionary.size() > 0:
		var last = duck_dictionary[duck_dictionary.size() - 1]
		var Last_ID = last["ID"]
		ID = Last_ID + 1
		duck_dictionary.append(get_duck_data())
	else:
		print("New duck")
		duck_dictionary.append(get_duck_data())

#Generates a random body for the duck
func generate_duck():
	var directory = DirAccess.open("res://Assets/Bodies")
	var files = []
	directory.list_dir_begin()
	var file_name = directory.get_next()
	while file_name != "":
		if file_name.get_extension().to_lower() in ["png"]:
			files.append(file_name)
		file_name = directory.get_next()
	directory.list_dir_end()
	Body = "res://Assets/Bodies/" + files[randi_range(0,files.size()-1)]


#Finds index of duck with matching ID in the list and sets that ducks values to the current ducks values
func update_save():
	print(ID)
	for i in range(duck_dictionary.size()):
		if duck_dictionary[i]["ID"] == ID:
			duck_dictionary[i] = get_duck_data()

#Takes the ID of the duck and returns the matching index in the list of ducks
func find_duck_Index_with_ID(ID):
	for i in range(duck_dictionary.size()):
		if duck_dictionary[i]["ID"] == ID:
			return i

#Sets defualt data of duck
func set_data():
	ID = 1
	Name = "MyFirstDuck"
	Experience = 0.0
	Level = 1
