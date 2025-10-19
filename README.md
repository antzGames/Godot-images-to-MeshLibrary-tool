# Godot 4.5 Tile images to MeshLibrary creation tool

This simple tool will covert all images in an import directory to a `MeshLibrary`.  Each image will have its own `QuadMesh` added to the `MeshLibrary`.

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
5. Verify the file extenion of your tile image files.  Make usre the initial period is present and the extension is **case sensitive**.
6. You can change the size of the `QuadMesh` if needed.  The default is 1.2 x 1.2 meters.
7. From the inspector click the **Generate MeshLibrary** button.
8. On success the `MeshLibrary` will be craeted and saved the export folder.
9. Error/Info are reported in the output console.

<img width="476.5" height="347.5" alt="s1" src="https://github.com/user-attachments/assets/dd583a53-7265-4057-8c9d-23d807e827c3" />

![s2](https://github.com/user-attachments/assets/cc6c1152-ea86-42d5-b380-1af1c1de3f29)
