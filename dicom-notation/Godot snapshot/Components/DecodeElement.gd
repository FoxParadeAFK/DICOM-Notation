extends RefCounted
class_name DecodeElement

var tagLibrary : Dictionary

var valueInformation : Dictionary[String, Variant]

var property : DICOMProperty
var transferSyntaxDictionary : Dictionary[String, TransferSyntax]
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]

func _init(_reader : FileAccess, _valueInformation : Dictionary[String, Variant]) -> void:
  var tagJSON : FileAccess = FileAccess.open('res://Godot snapshot/Library/DICOMTagLibrary.json', FileAccess.READ)
  tagLibrary = JSON.parse_string(tagJSON.get_as_text())
  property = DICOMProperty.new()

  valueInformation = _valueInformation

  #TODO - move them all into a different location
  #TODO - vr: ae, at, cs, lo, pn, sh and uc can be multiple values
  #NOTE - vr lo, lt, pn, sh, st, ut rely on tags 0008,0005 for character list
  valueRepresentationDictionary.set("CS", DecodeCodeString.new())
  valueRepresentationDictionary.set("DS", DecodeDecimalString.new())
  valueRepresentationDictionary.set("PN", DecodePersonName.new())
  valueRepresentationDictionary.set("DA", DecodeDate.new())
  valueRepresentationDictionary.set("LO", DecodeLongString.new())
  valueRepresentationDictionary.set("IS", DecodeIntegerString.new())
  valueRepresentationDictionary.set("OB", DecodeOtherByteString.new())
  valueRepresentationDictionary.set("OW", DecodeOtherWordString.new())
  valueRepresentationDictionary.set("SH", DecodeShortString.new())
  valueRepresentationDictionary.set("TM", DecodeTime.new())
  valueRepresentationDictionary.set("UI", DecodeUniqueIdentifier.new())
  valueRepresentationDictionary.set("UL", DecodeUnsignedLong.new())
  valueRepresentationDictionary.set("UN", DecodeUnknown.new())
  valueRepresentationDictionary.set("US", DecodeUnsignedShort.new())
  valueRepresentationDictionary.set("SQ", DecodeSequenceOfItems.new(valueRepresentationDictionary, property, tagLibrary))

  # group 0x00 element 0x00 vl 0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2", ImplicitVREndian.new(_reader, valueRepresentationDictionary, valueInformation, tagLibrary))
  # group 0x00 element 0x00 vr 0x00/0x000 vl 0x00/0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2.1", ExplicitVRLittleEndian.new(_reader, valueRepresentationDictionary))
  DeduceTransferSyntax("1.2.840.10008.1.2.1")

func TranslateTagName(_tag : String) -> String:
  if not tagLibrary.has(_tag): return "-".repeat(50)
  return tagLibrary.get(_tag)['name']

func DeduceTransferSyntax(_transferSyntaxUID : String) -> void: property.transferSyntax = transferSyntaxDictionary.get(_transferSyntaxUID)

func ReadElement() -> String:
  var tag : String = property.transferSyntax.ReadTag()
  var valueRepresentation : String = property.transferSyntax.ReadValueRepresentation()
  var valueLength : int = property.transferSyntax.ReadValueLength()
  var value : Variant = property.transferSyntax.ReadValue(valueRepresentation, valueLength)

  var name : String = TranslateTagName(tag)
  valueInformation.set(name if name != "-".repeat(50) else tag, value)

  return "%5s %50s %4s %11s\t%s" % [tag, name, valueRepresentation, valueLength, value]