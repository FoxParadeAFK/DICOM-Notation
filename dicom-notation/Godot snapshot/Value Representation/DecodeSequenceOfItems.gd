extends ValueRepresentation
class_name DecodeSequenceOfItems

var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]
var transferSyntaxUID : TransferSyntaxUID
var tagLibrary : Dictionary

func _init(_valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _transferSyntaxUID : TransferSyntaxUID, _tagLibrary : Dictionary) -> void: 
  valueRepresentationDictionary = _valueRepresentationDictionary
  transferSyntaxUID = _transferSyntaxUID
  tagLibrary = _tagLibrary

#FIXME - there is a lot in terms of the different types of vr avilable 
#TODO - intergrate a version of explicit and implicit with the type within the transfer syntax
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  var sequence : Array[Dictionary] 
  var item : Dictionary[String, Variant]
  var element : Dictionary[String, Variant] = {
    "name": "",
    "value": ""
  }
  while element["name"] != "Sequence Delimitation Item":
    element = ReadElement()
    if element["name"] == "Item":
      item.clear()
      continue
    
    elif element["name"] == "Item Delimitation Item":
      sequence.append(item.duplicate())
      continue
    
    elif element["name"] == "Sequence Delimitation Item": continue
    item.set(element["name"], element["value"])

  return sequence

func ReadElement() -> Dictionary[String, Variant]:
  var tag : String = transferSyntaxUID.transferSyntax.ReadTag()
  var name : String = transferSyntaxUID.transferSyntax.TranslateTagName(tag)
  var valueRepresentation : String = transferSyntaxUID.transferSyntax.ReadValueRepresentation()
  var valueLength : int = transferSyntaxUID.transferSyntax.ReadValueLength()
  var value : Variant = transferSyntaxUID.transferSyntax.ReadValue(valueRepresentation, valueLength)

  return {
    "name": name,
    "value": value
  }