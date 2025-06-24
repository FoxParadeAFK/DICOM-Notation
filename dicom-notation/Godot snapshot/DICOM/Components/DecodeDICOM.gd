extends Node3D

const folder : String = "06-13-2004-NA-PETCT Tumor Img. Skull Base to Mid-thigh-17769/102.000000-PET HeadNeck-29886" # not need for / at the beginning or end
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
  while reader.get_position() < metaInformationLength: 
    print(decoder.ReadElement()) # meta information # dead remains of print()

  decoder.DeduceTransferSyntax(valueInformation.get("Transfer Syntax UID"))

  while reader.get_position() < reader.get_length(): 
    (decoder.ReadElement()) # file data # dead remains of print()

  SaveRaw(file, valueInformation)
  SaveJSON(file, valueInformation)
  print("File %s complete" % file)

func SaveRaw(file : String, valueInformation : Dictionary[String, Variant]) -> void:
  var raw : FileAccess = FileAccess.open("%s/%s" % [rawPath, file.replace(".dcm", ".raw")], FileAccess.WRITE)
  
  if valueInformation["Bits Stored"] == 8:
    for word in valueInformation["Pixel Data"]: raw.store_8(word)
  else:
    for word in valueInformation["Pixel Data"]: raw.store_16(word)

  raw.close()

func SaveJSON(file : String, valueInformation : Dictionary[String, Variant]) -> void:
  valueInformation.erase("Pixel Data")
  var json : FileAccess = FileAccess.open("%s/%s" % [jsonPath, file.replace(".dcm", ".json")], FileAccess.WRITE)
  json.store_string(JSON.stringify(valueInformation, "\t", false))
  json.close()

func _ready() -> void:
  var pool : ThreadPool = ThreadPool.new(OS.get_processor_count() * 2)
  var content : PackedStringArray = ReadDirectory(relativeDirectory, ".dcm")

  var before : int = Time.get_ticks_msec()
  for file in content: pool.QueueTask(ReadDICOM.bind(file))
  
  var after : int = Time.get_ticks_msec()
  print(after - before)