extends Object
class_name TransferSyntax

var reader : FileAccess
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]

func _init(_reader : FileAccess, _valueRepresentationDictionary : Dictionary[String, ValueRepresentation]) -> void:
  reader = _reader
  valueRepresentationDictionary = _valueRepresentationDictionary

func ReadTag() -> String: return ""

func ReadValueRepresentation() -> String: return ""

func ReadValueLength() -> int: return 0

func ReadValue(_valueRepresentation : String, _valueLength : int) -> Variant: return ""

func Reverse(_stream : PackedByteArray) -> PackedByteArray:
  _stream.reverse()
  return _stream