extends Node3D

const folder : String = "1.000000-T2Post1-61265"
const relativeDirectory : String = "res://%s" % folder
const rawPath : String = "res://Parsed/%s/Raw" % folder
const jsonPath : String = "res://Parsed/%s/JSON" % folder

func ReadDirectory(path : String, target : String) -> Array:
	var directory : DirAccess = DirAccess.open(path)
	if not directory: return PackedStringArray()

	return Array(directory.get_files()).filter(func(file : String): return file.ends_with(target))

func ReadDICOM(file : String) -> void:
	var valueInformation : Dictionary[String, Variant]
	var reader : FileAccess = FileAccess.open("%s/%s" % [relativeDirectory, file], FileAccess.READ)
	var decoder : DecodeElement = DecodeElement.new(reader, valueInformation)

	reader.seek(128) # skip "file preamble" 128 bytes
	reader.get_buffer(4).get_string_from_ascii() # "dicom prefix" should spell "DICM" 4 bytes
	decoder.ReadElement() # "file meta information group length"

	var metaInformationLength : int = valueInformation.get("File Meta Information Group Length") + reader.get_position()
	while reader.get_position() < metaInformationLength: decoder.ReadElement() # meta information
	decoder.DeduceTransferSyntax(valueInformation.get("Transfer Syntax UID"))

	while reader.get_position() < reader.get_length(): decoder.ReadElement() # file data

	SaveRaw(file, valueInformation)
	SaveJSON(file, valueInformation)

func SaveRaw(file : String, valueInformation : Dictionary[String, Variant]) -> void:
	#TODO - assumes OW however it can be OB in which this method is not necessary
	#NOTE - we can tell based on the image height and width. If OW, the value will be double in length of height * width
	var raw : FileAccess = FileAccess.open("%s/%s" % [rawPath, file.replace(".dcm", ".raw")], FileAccess.WRITE)
	for word in valueInformation["Pixel Data"]: raw.store_16(word)
	raw.close()

func SaveJSON(file : String, valueInformation : Dictionary[String, Variant]) -> void:
	valueInformation.erase("Pixel Data")
	var json : FileAccess = FileAccess.open("%s/%s" % [jsonPath, file.replace(".dcm", ".json")], FileAccess.WRITE)
	json.store_string(JSON.stringify(valueInformation))
	json.close()

func _ready() -> void:
	var content : PackedStringArray = ReadDirectory(relativeDirectory, ".dcm")
	for file in content: ReadDICOM(file)