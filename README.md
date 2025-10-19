# Godot 4.5: Tile images to MeshLibrary creation tool

This simple tool will covert all images in an import directory to a `MeshLibrary`.  Each image will have its own `QuadMesh` added to the `MeshLibrary`.

https://github.com/user-attachments/assets/fe622faa-cae0-47d6-bbf9-f5fa7503bfe5


## Using this project as your template

Downloading this project repository makes the solution work with one button click.

Once downloaded and started in Godot 4.5.1 editor:

1. Open the `mesh_library_creator.tscn` scene.
2. Click the **Generate MeshLibrary** button.
3. The `MeshLibrary` will be created and saved to: `res://assets/export/mesh_libraries/mesh_library.meshlib`

Note: Just replace the sample tile images in the import directory with your own tile images, and reclick the **Generate MeshLibrary** button from the inspector.  Its that simple.

## How to use the tool in your own projects

1. Copy the `mesh_library_creator` directory which includes the scene and script to your project.
2. Open the `mesh_library_creator.tscn` scene.
3. From the inspector set the correct import directory of the individual tile images that you want to make a `MeshLibrary` for.
4. From the inspector set the correct export directory.
5. Verify the file extenion of your tile image files.  Make sure the initial period is present and the extension is **case sensitive**.
6. You can change the size of the `QuadMesh` if needed.  The default is 1.2 x 1.2 meters.
7. From the inspector click the **Generate MeshLibrary** button.
8. On success the `MeshLibrary` will be created and saved to the export folder.
9. Error/Info messages will be reported in the output console.

<img width="426.5" height="347.5" alt="s1" src="https://github.com/user-attachments/assets/dd583a53-7265-4057-8c9d-23d807e827c3" />

![s2](https://github.com/user-attachments/assets/cc6c1152-ea86-42d5-b380-1af1c1de3f29)

## Customizing your mesh settings further

You can modify the `create_mesh_library()` method in the `mesh_library_creator.gd` script to further customize the `QuadMesh`'s mesh settings.

Currently, the mesh settings sets `cull_mode` to **disable** and sets the `texture_filter` to **Nearest Mipmap**.

You are free to add/modify the mesh setting to your requirements.

```gdscript
		# customize your mesh setting here
		mesh.size = size_of_mesh # size
		mesh.surface_set_material(0, mat) # set material
		mesh.surface_get_material(0).albedo_texture = texture # set texture
		mesh.surface_get_material(0).cull_mode = 2 # disabled
		mesh.surface_get_material(0).texture_filter = 2 # Nearest Mipmap
```

## Can I use a BoxMesh or any other PrimitiveMesh instead of QuadMesh?

Absolutely, but you will need to change:

```gdscript
	var mesh = QuadMesh.new()
```

To `BoxMesh` or whatever you need, but you might have to code some UV mapping stuff.  I laid the foundation, but you will need to handle this in code yourself.

## I need to generate multiple mesh libraries

Reclicking the **Generate MeshLibrary** button from the inspector will overwrite any previous `MeshLibrary` with the same export directory and file name.

To build multilple mesh libraries, without overwriting previous built mesh libraries, just **make a copy** of the `mesh_library_creator.tscn` scene and config different import/export and file name settings in the inspector.
