extends TransferSyntax
class_name ImplicitVREndian

var valueInformation : Dictionary[String, Variant]
var tag : String

func _init(_reader : FileAccess, _valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _tagLibrary : Dictionary, _valueInformation : Dictionary[String, Variant]) -> void: 
  super._init(_reader, _valueRepresentationDictionary, _tagLibrary)
  valueInformation = _valueInformation

func ReadTag() -> String:
  var group : PackedByteArray = Reverse(reader.get_buffer(2))
  var element : PackedByteArray = Reverse(reader.get_buffer(2))
  tag = "%s %s" % [group.hex_encode().to_upper(), element.hex_encode().to_upper()]
  return tag

func ReadValueRepresentation() -> String:
  if not tagLibrary.has(tag): return "|"
  var tagEntry : Dictionary = tagLibrary.get(tag)

  if not tagEntry.has("reference name"): return tagEntry.get("vr")

  var referenceName : String = tagEntry.get("reference name")
  var referenceValue : String = str(valueInformation.get(referenceName))
  var tagEntryValueRepresentationDictionary : Dictionary = tagEntry.get('vr')
  return tagEntryValueRepresentationDictionary.get(referenceValue, "|")

func ReadValueLength() -> int:
  var valueLength : int = reader.get_32()
  return 0 if valueLength == 0xFFFFFFFF else valueLength

func ReadValue(_valueRepresentation : String, _valueLength : int) -> Variant:
  if not valueRepresentationDictionary.has(_valueRepresentation): return valueRepresentationDictionary.get("UN").Translate(reader, _valueLength)
  return valueRepresentationDictionary.get(_valueRepresentation).Translate(reader, _valueLength)
