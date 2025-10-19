@tool
class_name MeshLibraryCreator
extends Node
## This tool creates a [MeshLibrary] of [QuadMesh] from image tiles.
##
## Each individual image tile will create a [QuadMesh] in the [MeshLibrary].
## Any Godot supported image format (PNG, WebP, GIF, etc) will work.
## Made by Antz!
## 
## @tutorial(GitHub Repository): https://github.com/antzGames/Godot-images-to-MeshLibrary-tool

## Directory where the tile images are located.
@export_dir var import_dir : String
## Directory where mesh library will be exported.
@export_dir var export_dir : String
## Tile images file extension. You must include the initial period. Case sensitive!
@export var image_extention : String = ".png"

## Name of the exported [MeshLibrary].
@export var export_file_name : String = "mesh_library"

## Size of QuadMesh as [Vector2] in meters
@export var size_of_mesh: Vector2  = Vector2(1.2, 1.2)

@export_tool_button("\nGenerate MeshLibrary\n\n", "MeshLibrary")
var generate_action = create_mesh_library

func _ready() -> void:
	print_rich("Just press the [color=yellow]Generate MeshLibrary[/color] button in the inspector!")

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		await get_tree().create_timer(2.5).timeout
		get_tree().quit(1)

func create_mesh_library():
	print("\n------------------------------------")
	print_rich("🐜 [color=red][b]Antz[/b][/color] [color=green]MeshLibrary Creator Tool[/color] ⛏️")
	print("------------------------------------\n")
	
	# check export variables
	if not import_dir or import_dir.length() == 0:
		printerr("⛔Import directory not set!")
		return
	elif not export_dir or export_dir.length() == 0:
		printerr("⛔Export directory not set!")
		return
	elif not export_file_name or export_file_name.length() == 0:
		printerr("⛔Export file not set!")
		return

	var files = []
	
	# open import directory
	var dir = DirAccess.open(import_dir)
	
	# get all PNG files in directory
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(image_extention):
				files.append(file_name)
			file_name = dir.get_next()
	else:
		printerr("⛔Could not open import directory!")
		return
	
	# Stop if no files found
	if files.size() == 0:
		printerr("⛔No image tiles found in import directory!")
		return
	
	print_rich("✅Image tiles found: [color=yellow]", files, "[/color]\n")
	
	# Create mesh library
	var x: int = 0
	var mesh_library: MeshLibrary = MeshLibrary.new()
	
	# loop tile image files
	for file_name: String in files:
		print_rich("Creating item: ", x , " - [color=yellow]", str(file_name.split(".")[0],"[/color]"))

		var texture = load(str(import_dir, "/", file_name))
		var mat: StandardMaterial3D = StandardMaterial3D.new()
		var mesh = QuadMesh.new()
		
		# customize your mesh setting here
		mesh.size = size_of_mesh # size
		mesh.surface_set_material(0, mat) # set material
		mesh.surface_get_material(0).albedo_texture = texture # set texture
		mesh.surface_get_material(0).cull_mode = 2 # disabled
		mesh.surface_get_material(0).texture_filter = 2 # Nearest Mipmap
		
		# add mesh to mesh library
		mesh_library.create_item(x)
		mesh_library.set_item_name(x, str(file_name.split(".")[0]))
		mesh_library.set_item_mesh(x, mesh)
		x += 1

	# check if a meshlib file already exists, if so delete it
	var delete_access = DirAccess.open(export_dir)
	
	# check if export directory valid
	if not delete_access:
		printerr("⛔Error accessing export directory!")
		return
		
	# note if file export_file_name changed then old file will not be deleted
	delete_access.remove(str(export_dir, "/", export_file_name, ".meshlib"))

	# save new mesh library to export directory
	var error = ResourceSaver.save(mesh_library, str(export_dir, "/", export_file_name, ".meshlib"))
	
	# check if resource saved ok
	if error:
		printerr("⛔Error saving resource to export directory!")
		return
		
	print_rich(str("\n✅ [color=yellow]", export_dir, "/[/color][color=purple]", export_file_name, ".meshlib[/color]", " has been created."))
	print_rich("✅ [color=green]Done![/color]")
