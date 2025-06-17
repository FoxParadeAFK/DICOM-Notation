extends RefCounted
class_name DecodeElement

var tagLibrary : Dictionary
var transferSyntaxUID : TransferSyntaxUID
var valueInformation : Dictionary[String, Variant]

var transferSyntaxDictionary : Dictionary[String, TransferSyntax]
var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]

func _init(_reader : FileAccess, _valueInformation : Dictionary[String, Variant]) -> void:
  var tagJSON : FileAccess = FileAccess.open('res://Godot snapshot/Library/DICOMTagLibrary.json', FileAccess.READ)
  tagLibrary = JSON.parse_string(tagJSON.get_as_text())

  valueInformation = _valueInformation
  transferSyntaxUID = TransferSyntaxUID.new()

  #TODO - vr: ae, at, cs, lo, pn, sh and uc can be multiple values (okay apparently through the doc, that is not the case any more...it's more)
  #NOTE - vr lo, lt, pn, sh, st, ut rely on tags 0008,0005 for character list
  valueRepresentationDictionary.set("CS", DecodeCodeString.new())
  valueRepresentationDictionary.set("DS", DecodeDecimalString.new())
  valueRepresentationDictionary.set("PN", DecodePersonName.new())
  valueRepresentationDictionary.set("DA", DecodeDate.new())
  valueRepresentationDictionary.set("LO", DecodeLongString.new())
  valueRepresentationDictionary.set("IS", DecodeIntegerString.new())
  valueRepresentationDictionary.set("OB", DecodeOtherByteString.new())
  valueRepresentationDictionary.set("OW", DecodeOtherWordString.new())
  valueRepresentationDictionary.set("TM", DecodeTime.new())
  valueRepresentationDictionary.set("UI", DecodeUniqueIdentifier.new())
  valueRepresentationDictionary.set("UL", DecodeUnsignedLong.new())
  valueRepresentationDictionary.set("UN", DecodeUnknown.new())
  valueRepresentationDictionary.set("US", DecodeUnsignedShort.new())
  valueRepresentationDictionary.set("SQ", DecodeSequenceOfItems.new(transferSyntaxUID))
  valueRepresentationDictionary.set("SH", DecodeShortString.new())

  # group 0x00 element 0x00 vl 0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2", ImplicitVREndian.new(_reader, valueRepresentationDictionary, tagLibrary, valueInformation))
  # group 0x00 element 0x00 vr 0x00/0x000 vl 0x00/0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2.1", ExplicitVRLittleEndian.new(_reader, valueRepresentationDictionary, tagLibrary))
  DeduceTransferSyntax("1.2.840.10008.1.2.1")

func DeduceTransferSyntax(_transferSyntaxUID : String) -> void: transferSyntaxUID.transferSyntax = transferSyntaxDictionary.get(_transferSyntaxUID)

func ReadElement() -> String:
  var tag : String = transferSyntaxUID.transferSyntax.ReadTag()
  var name : String = transferSyntaxUID.transferSyntax.TranslateTagName(tag)
  var valueRepresentation : String = transferSyntaxUID.transferSyntax.ReadValueRepresentation()
  var valueLength : int = transferSyntaxUID.transferSyntax.ReadValueLength()
  var value : Variant = transferSyntaxUID.transferSyntax.ReadValue(valueRepresentation, valueLength)

  valueInformation.set(name if not name.contains("-") else tag, value)

  return "%5s %50s %4s %11s\t%s" % [tag, name, valueRepresentation, valueLength, value] # debug purposes only