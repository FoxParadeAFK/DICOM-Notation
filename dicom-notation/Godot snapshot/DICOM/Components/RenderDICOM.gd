extends Node3D

const folder : String = "06-13-2004-NA-PETCT Tumor Img. Skull Base to Mid-thigh-17769/4.000000-CT HeadNeck  3.0  eFoV-85383" # not need for / at the beginning or end
const relativeDirectory : String = "res://%s" % folder
const rawPath : String = "res://Parsed/%s/Raw" % folder
const jsonPath : String = "res://Parsed/%s/JSON" % folder

var pool : ThreadPool

func ReadDirectory(path : String, target : String) -> Array:
  var directory : DirAccess = DirAccess.open(path)
  if not directory: return PackedStringArray()
  
  return Array(directory.get_files()).filter(func(file : String): return file.ends_with(target))

func ReadImage(_rawContent : Array, _jsonContent : Array, _layer : int) -> void:
  var raw : FileAccess = FileAccess.open("%s/%s" % [rawPath, _rawContent[_layer]], FileAccess.READ)
  var json : Dictionary = JSON.parse_string(FileAccess.open("%s/%s" % [jsonPath, _jsonContent[_layer]], FileAccess.READ).get_as_text())

  var data : PackedByteArray = TranslateImage(raw, json, raw.get_length())
  RenderImage(json, data, _layer)

func TranslateImage(_raw : FileAccess, _json : Dictionary, _rawLength : int) -> PackedByteArray:
  var dimension : int = _json["Rows"] * _json["Columns"]
  var bytes : PackedByteArray
  if _raw.get_length() == dimension:
    while _raw.get_position() < _raw.get_length():
      var byte : int = _raw.get_8()
      bytes.append(byte)
    return bytes
  
  var largestPixel : int = _json["Largest Image Pixel Value"]
  while _raw.get_position() < _raw.get_length():
    var byte : int = round(_raw.get_16() / (largestPixel / 256.0))
    bytes.append(byte)

  return bytes  

func RenderImage(_json : Dictionary, _data : PackedByteArray, _layer : int) -> void:
  var image = Image.create_from_data(_json["Columns"], _json["Rows"], false, Image.FORMAT_L8, _data)

  var renderer : Sprite3D = Sprite3D.new()
  renderer.texture = ImageTexture.create_from_image(image)
  renderer.modulate.a = 0.1
  renderer.position.z = -renderer.pixel_size * _layer
  self.call_deferred("add_child", renderer)

  print("Image %s complete" % _layer)
  
func _ready() -> void:
  var rawContent : Array = ReadDirectory(rawPath, ".raw")
  var jsonContent : Array = ReadDirectory(jsonPath, ".json")
  pool = ThreadPool.new(OS.get_processor_count() * 2)

  if rawContent.size() != jsonContent.size(): return

  for cursor in range(rawContent.size()):
    pool.QueueTask(ReadImage.bind(rawContent, jsonContent, cursor))
