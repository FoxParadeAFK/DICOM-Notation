extends Node3D

var valueInformation : Dictionary[String, Variant]

func _ready() -> void:
	var reader : FileAccess = FileAccess.open('res://1.000000-T2Post1-61265/1-01.dcm', FileAccess.READ)
	var decoder : DecodeElement = DecodeElement.new(reader, valueInformation)

	reader.seek(128) # skip 'file preamble' 128 bytes
	print(reader.get_buffer(4).get_string_from_ascii()) # 'dicom prefix' should spell 'DICM' 4 bytes
	print(decoder.ReadElement()) # 'file meta information group length'

	var metaInformationLength : int = valueInformation.get("File Meta Information Group Length") + reader.get_position()
	while reader.get_position() < metaInformationLength: print(decoder.ReadElement()) # meta information

	decoder.DeduceTransferSyntax(valueInformation.get("Transfer Syntax UID"))

	while reader.get_position() < reader.get_length(): print(decoder.ReadElement()) # file data
	
	var fileData : Dictionary[String, Variant] = valueInformation.duplicate(true)
	fileData.erase("Pixel Data")

	var json = FileAccess.open("res://Godot snapshot/Parsed Data/1-01.json", FileAccess.WRITE)
	json.store_string(JSON.stringify(fileData, "\t", false))
	json.close()

	var raw = FileAccess.open("res://Godot snapshot/Parsed Data/1-01.raw", FileAccess.WRITE)
	raw.store_string(JSON.stringify(valueInformation["Pixel Data"]))
	raw.close()