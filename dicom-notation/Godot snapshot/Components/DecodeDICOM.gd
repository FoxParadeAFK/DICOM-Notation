extends Node3D

var valueInformation : Dictionary[String, Variant]

func _ready() -> void:
	var reader : FileAccess = FileAccess.open('res://1.000000-T2Post1-61265/1-01.dcm', FileAccess.READ)
	var decoder : DecodeElement = DecodeElement.new(reader, valueInformation)

	reader.seek(128) # skip 'file preamble' 128 bytes
	print(reader.get_buffer(4).get_string_from_ascii()) # 'dicom prefix' should spell 'DICM' 4 bytes
	print(decoder.ReadElement()) # 'file meta information group length'

	var metaInformationLength : int = valueInformation.get("File Meta Information Group Length") + reader.get_position()
	while reader.get_position() < metaInformationLength: print(decoder.ReadElement())