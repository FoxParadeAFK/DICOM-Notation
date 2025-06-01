extends Node3D

func _ready() -> void:
	var reader : FileAccess = FileAccess.open('res://Godot snapshot/DICOM Files/1-01.dcm', FileAccess.READ)

	reader.seek(128) # skip 'file preamble' 128 bytes
	print(reader.get_buffer(4).get_string_from_ascii()) # 'dicom prefix' should spell 'DICM' 4 bytes