extends Node3D

const folder : String = "1.000000-T2Post1-61265"
const relativeDirectory : String = "res://%s" % folder
const rawPath : String = "res://Parsed/%s/Raw" % folder
const pngPath : String = "res://Parsed/%s/PNG" % folder

func ReadDirectory(path : String) -> PackedStringArray:
	var directory : DirAccess = DirAccess.open(path)
	if not directory: return PackedStringArray()

	return directory.get_files()

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
	RenderImage(file, valueInformation)

func RenderImage(file : String, valueInformation : Dictionary[String, Variant]) -> void:
	var pixelData : FileAccess = FileAccess.open("%s/%s" % [rawPath, file.replace(".dcm", ".raw")], FileAccess.READ)
	var bytes : PackedByteArray
	while pixelData.get_position() < pixelData.get_length():
		var byte : int = round(pixelData.get_16() / (valueInformation["Largest Image Pixel Value"][0] / 256))
		bytes.append(byte)

	Image.create_from_data(512, 512, false, Image.FORMAT_L8, bytes).save_png("%s/%s" % [pngPath, file.replace(".dcm", ".png")])

func SaveRaw(file : String, valueInformation : Dictionary[String, Variant]) -> void:
	var raw : FileAccess = FileAccess.open("%s/%s" % [rawPath, file.replace(".dcm", ".raw")], FileAccess.WRITE)
	for word in valueInformation["Pixel Data"]: raw.store_16(word)
	
	raw.close()

func _ready() -> void:
	var content : PackedStringArray = ReadDirectory(relativeDirectory)
	for file in content: ReadDICOM(file)