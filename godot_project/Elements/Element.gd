extends Node2D
# Elements are each individual item that can show up in the game world -A

class_name Element


# nom de l'élément
# element name
var name_element : String

# Dossier parent
# Parent folder
var parent

# position dans la grille (unité : case) en tant qu'enfant
# position in grid (unit: box) as child
var position_grid : Vector2

# type de l'élément
# element type
enum Type{
	FOLDER,
	PASSWORD,
	CHECKPOINT_FILE,
	CHECKPOINT_ELEMENT,
	PRIVILEDGE,
	TUTO,
	SABLIER,
	GHOST_FOLDER
}
var type

# Paramètre de protection
# Protection setting
enum Protection{
	JAUNE,
	ORANGE,
	ROUGE
}
var protection_level

# Mot de passe pour accéder au contenu
# à ne pas confondre avec "password_content", le mot de passe
# que représente un PasswordFile
# Password to access content
# not to be confused with "password_content", the password
# what does a PasswordFile represent
var password_access:String

# Est zippé ?
# Is it zipped?
var is_zipped : bool


var has_been_compensated = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_position_in_grid(pos:Vector2):
	GridUtils.scale_sprite_node(get_node("Sprite"), Globals.current_folder)
	position = GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, pos)
	if not has_been_compensated:
		GridUtils.compensate_scale_pos(get_node("Sprite"), Globals.current_folder)
		has_been_compensated = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_icon():
	pass

func Initialize(_parent, _position:Vector2, _type, _protection_level = Protection.JAUNE, _password="", _is_zipped = false):
	parent = _parent
	if parent!=null:
		name_element=parent.name_element + "/"+ Type.keys()[_type] +"_" + str(parent.children.size())
	else:
		name_element="root"
	name=name_element
	position_grid = _position
	type=_type
	protection_level=_protection_level
	password_access=_password
	is_zipped=_is_zipped
	set_icon()

func set_name(txt:String):
	if parent!=null:
		name_element=parent.name_element + "/"+ txt
	else:
		name_element="root"
	
func refresh():
	set_icon()

func setPosition(pos : Vector2):
	position = pos

func setNameElement(name_el : String):
	name_element = name_el

func setParent(_parent):
	parent = _parent

func delete():
	#retirer du parent
	parent.children.erase(self)
#	for i in range(parent.children.size()):
#		if parent.children[i]==self:
#			parent.children...
	#retirer de la scène et de la mémoire
	queue_free()

func print():
	print(name_element)

func get_depth_from_parent()->int:
	if parent!=null:
		return 1+parent.get_depth_from_parent()
	return 1
