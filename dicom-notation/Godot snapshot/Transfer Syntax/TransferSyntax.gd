extends Object
class_name TransferSyntax

var reader : FileAccess
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]
var tagLibrary : Dictionary

func Reverse(_stream : PackedByteArray) -> PackedByteArray:
  _stream.reverse()
  return _stream

func GetCursorPosition() -> int:
  return reader.get_position()

func _init(_reader : FileAccess, _valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _tagLibrary : Dictionary) -> void:
  reader = _reader
  valueRepresentationDictionary = _valueRepresentationDictionary
  tagLibrary = _tagLibrary

func ReadTag() -> String: return ""

func TranslateTagName(_tag : String) -> String:
  if not tagLibrary.has(_tag): return "-".repeat(50)
  return tagLibrary.get(_tag)['name']

func ReadValueRepresentation() -> String: return ""

func ReadValueLength() -> int: return 0

func ReadItemLength(_name : String) -> int:
  if _name not in ["Item", "Item Delimitation Item", "Sequence Delimitation Item"]: return 0
  return reader.get_32()

func ReadValue(_valueRepresentation : String, _valueLength : int) -> Variant: return ""

