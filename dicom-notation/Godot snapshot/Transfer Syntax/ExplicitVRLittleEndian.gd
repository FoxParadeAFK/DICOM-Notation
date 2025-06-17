extends TransferSyntax
class_name ExplicitVRLittleEndian

var specialValueRepresentation : Array[String] = ["OB", "OW", "OF", "SQ", "UT", "UN"]
var valueRepresentation : String

func _init(_reader : FileAccess, _valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _tagLibrary : Dictionary) -> void: super._init(_reader, _valueRepresentationDictionary, _tagLibrary)

func ReadTag() -> String:
  var group : PackedByteArray = Reverse(reader.get_buffer(2))
  var element : PackedByteArray = Reverse(reader.get_buffer(2))
  return "%s %s" % [group.hex_encode().to_upper(), element.hex_encode().to_upper()]

func ReadValueRepresentation() -> String:
  valueRepresentation = reader.get_buffer(2).get_string_from_ascii()
  if valueRepresentation in specialValueRepresentation: reader.get_buffer(2) # skip reserved bytes 0x0000
  return valueRepresentation

func ReadValueLength() -> int: 
  var valueLength : int = reader.get_32() if valueRepresentation in specialValueRepresentation else reader.get_16()
  return 0 if valueLength == 0xFFFFFFFF else valueLength

func ReadValue(_valueRepresentation : String, _valueLength : int) -> Variant: 
  if not valueRepresentationDictionary.has(_valueRepresentation): return valueRepresentationDictionary.get("UN").Translate(reader, _valueLength)
  return valueRepresentationDictionary.get(_valueRepresentation).Translate(reader, _valueLength)