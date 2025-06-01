extends Node3D
class_name DecodeElement

var valueInformation : Dictionary[String, Variant]

var transferSyntax : TransferSyntax
var transferSyntaxDictionary : Dictionary[String, TransferSyntax]

var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]

func _init(_reader : FileAccess, _valueInformation : Dictionary[String, Variant]) -> void:
  valueInformation = _valueInformation

  valueRepresentationDictionary.set("UL", DecodeUnsignedLong.new())

  # group 0x00 element 0x00 vr 0x00/0x000 vl 0x00/0x0000 v 0xN/A 
  transferSyntaxDictionary.set("1.2.840.10008.1.2.1", ExplicitVRLittleEndian.new(_reader, valueRepresentationDictionary))
  DeduceTransferSyntax("1.2.840.10008.1.2.1")

func DeduceTransferSyntax(_transferSyntaxUID : String) -> void:
  transferSyntax = transferSyntaxDictionary.get(_transferSyntaxUID)

func ReadElement() -> String:
  var tag : String = transferSyntax.ReadTag()
  var valueRepresentation : String = transferSyntax.ReadValueRepresentation()
  var valueLength : int = transferSyntax.ReadValueLength()
  var value : Variant = transferSyntax.ReadValue(valueRepresentation, valueLength)

  return "%5s %4s %7s \t %s" % [tag, valueRepresentation, valueLength, value]