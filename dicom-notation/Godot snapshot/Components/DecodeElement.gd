extends RefCounted
class_name DecodeElement

var tagLibrary : Dictionary

var valueInformation : Dictionary[String, Variant]

var transferSyntax : TransferSyntax
var transferSyntaxDictionary : Dictionary[String, TransferSyntax]
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]

func _init(_reader : FileAccess, _valueInformation : Dictionary[String, Variant]) -> void:
  var tagJSON : FileAccess = FileAccess.open('res://Godot snapshot/Library/DICOMTagLibrary.json', FileAccess.READ)
  tagLibrary = JSON.parse_string(tagJSON.get_as_text())

  valueInformation = _valueInformation

  #TODO - move them all into a different location
  valueRepresentationDictionary.set("CS", DecodeCodeString.new())
  valueRepresentationDictionary.set("DA", DecodeDate.new())
  valueRepresentationDictionary.set("OB", DecodeOtherByteString.new())
  valueRepresentationDictionary.set("SH", DecodeShortString.new())
  valueRepresentationDictionary.set("TM", DecodeTime.new())
  valueRepresentationDictionary.set("UI", DecodeUniqueIdentifier.new())
  valueRepresentationDictionary.set("UL", DecodeUnsignedLong.new())

  # group 0x00 element 0x00 vl 0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2", ImplicitVREndian.new(_reader, valueRepresentationDictionary, valueInformation, tagLibrary))
  # group 0x00 element 0x00 vr 0x00/0x000 vl 0x00/0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2.1", ExplicitVRLittleEndian.new(_reader, valueRepresentationDictionary))
  DeduceTransferSyntax("1.2.840.10008.1.2.1")

func TranslateTagName(_tag : String) -> String:
  if not tagLibrary.has(_tag): return "-".repeat(50)
  return tagLibrary.get(_tag)['name']

func DeduceTransferSyntax(_transferSyntaxUID : String) -> void: transferSyntax = transferSyntaxDictionary.get(_transferSyntaxUID)

func ReadElement() -> String:
  var tag : String = transferSyntax.ReadTag()
  var valueRepresentation : String = transferSyntax.ReadValueRepresentation()
  var valueLength : int = transferSyntax.ReadValueLength()
  var value : Variant = transferSyntax.ReadValue(valueRepresentation, valueLength)

  var name : String = TranslateTagName(tag)
  valueInformation.set(name, value)

  return "%5s %50s %4s %7s\t%s" % [tag, name, valueRepresentation, valueLength, value]