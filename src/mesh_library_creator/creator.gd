extends Node

## Directory where the tile images are located.
@export_dir var import_dir : String
## Directory where mesh library will be exported.
@export_dir var export_dir : String
## Name of the exported [MeshLibrary].
@export_dir var export_file_name : String = "mesh_library"
## You must include the initial period. Case sensitive!
@export var extention : String = ".png"
## Size of QuadMesh as [Vector2] in meters
@export var size_of_mesh: Vector2  = Vector2(1.2, 1.2)

var abs_import_dir: String
var abs_export_dir: String

func _ready() -> void:
	if not import_dir or import_dir.length() == 0:
		printerr("Import directory not set!")
		_exit_app()
	elif not export_dir or export_dir.length() == 0:
		printerr("Export directory not set!")
		_exit_app()
	else:
		import_dir += "/"
		export_dir += "/"
		abs_import_dir = ProjectSettings.globalize_path(import_dir)
		abs_export_dir = ProjectSettings.globalize_path(export_dir)
		
		#print("Import directory absolute: ", abs_import_dir)
		#print("Import directory project: ", import_dir)
		#print("Export directory absolute: ", abs_export_dir)
		#print("Export directory project: ", export_dir, "\n")
		
		create_mesh_library()

func create_mesh_library():
	var files = []
	
	# open import directory
	var dir = DirAccess.open(abs_import_dir)
	
	# get all PNG files in directory
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(extention):
				files.append(file_name)
			file_name = dir.get_next()
	else:
		printerr("Could not open import directory!")
		_exit_app()
		return
	
	# Stop if no files found
	if files.size() == 0:
		printerr("No image tiles found in import directory!")
		_exit_app()
		return
	
	print("Files: ", files, "\n")
	
	# Create mesh library
	var x: int = 0
	var mesh_library: MeshLibrary = MeshLibrary.new()
	
	for file_name: String in files:
		print("Creating item: ", x , " - ", str(file_name.split(".")[0]))

		var texture = load(str(import_dir, file_name))
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

	# check if a meshlib file exists, if so delete it
	var delete_access = DirAccess.open(abs_export_dir)
	
	# check if export dir valid
	if not delete_access:
		printerr("Error accessing export directory!")
		_exit_app()
		return
		
	delete_access.remove(str(abs_export_dir, "mesh_library.meshlib"))

	# save new mesh library to export directory
	var error = ResourceSaver.save(mesh_library, str(export_dir, export_file_name, ".meshlib"))
	
	# check if resourced saved ok
	if error:
		printerr("Error saving resource to export directory!")
		_exit_app()
		return
		
	print(str("\n", export_dir, export_file_name, ".meshlib", " has been created."))
	print("\nDone!")
	
	_exit_app()

func _exit_app():
	# give some time to log everything to console
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()
