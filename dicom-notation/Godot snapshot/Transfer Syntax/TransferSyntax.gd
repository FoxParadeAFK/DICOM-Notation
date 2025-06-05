extends Object
class_name TransferSyntax

var reader : FileAccess
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]
var tagLibrary : Dictionary

func _init(_reader : FileAccess, _valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _tagLibrary : Dictionary) -> void:
  reader = _reader
  valueRepresentationDictionary = _valueRepresentationDictionary
  tagLibrary = _tagLibrary

func ReadTag() -> String: return ""

func ReadValueRepresentation() -> String: return ""

func ReadValueLength() -> int: return 0

func ReadValue(_valueRepresentation : String, _valueLength : int) -> Variant: return ""

func TranslateTagName(_tag : String) -> String:
  if not tagLibrary.has(_tag): return "-".repeat(50)
  return tagLibrary.get(_tag)['name']

func Reverse(_stream : PackedByteArray) -> PackedByteArray:
  _stream.reverse()
  return _stream