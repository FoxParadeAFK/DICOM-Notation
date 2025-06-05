extends Node3D

var valueInformation : Dictionary[String, Variant]
@export var sprite3D : Sprite3D

func _ready() -> void:
	var reader : FileAccess = FileAccess.open("res://1.000000-T2Post1-61265/1-18.dcm", FileAccess.READ)
	var decoder : DecodeElement = DecodeElement.new(reader, valueInformation)

	reader.seek(128) # skip "file preamble" 128 bytes
	print(reader.get_buffer(4).get_string_from_ascii()) # "dicom prefix" should spell "DICM" 4 bytes
	print(decoder.ReadElement()) # "file meta information group length"

	var metaInformationLength : int = valueInformation.get("File Meta Information Group Length") + reader.get_position()
	while reader.get_position() < metaInformationLength: print(decoder.ReadElement()) # meta information

	decoder.DeduceTransferSyntax(valueInformation.get("Transfer Syntax UID"))

	while reader.get_position() < reader.get_length(): decoder.ReadElement() # file data
	
	#TODO - clean this up after we figure out how to render the pixel data
	var fileData : Dictionary[String, Variant] = valueInformation.duplicate(true)
	fileData.erase("Pixel Data")

	var json = FileAccess.open("res://Godot snapshot/Parsed Data/1-18.json", FileAccess.WRITE)
	json.store_string(JSON.stringify(fileData, "\t", false))
	json.close()

	var raw = FileAccess.open("res://Godot snapshot/Parsed Data/1-18.raw", FileAccess.WRITE)
	for word in valueInformation["Pixel Data"]:
		raw.store_16(word)
	
	raw.close()

	var imageData : FileAccess = FileAccess.open("res://Godot snapshot/Parsed Data/1-18.raw", FileAccess.READ)
	var byteData : PackedByteArray
	while imageData.get_position() < imageData.get_length():
		var word : int = imageData.get_16()
		var byte : int = round(word / 21.59375)
		byteData.append(byte)

	var mriImage : Image = Image.create_from_data(512, 512, false, Image.FORMAT_L8, byteData)
	mriImage.save_png("res://Godot snapshot/Parsed Data/1-18.png")