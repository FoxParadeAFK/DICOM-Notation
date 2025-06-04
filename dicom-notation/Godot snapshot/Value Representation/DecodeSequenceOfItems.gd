extends ValueRepresentation
class_name DecodeSequenceOfItems

var valueRepresentationDictionary : Dictionary[String, ValueRepresentation]
var property : DICOMProperty
var tagLibrary : Dictionary
func _init(_valueRepresentationDictionary : Dictionary[String, ValueRepresentation], _property : DICOMProperty, _tagLibrary : Dictionary) -> void: 
  valueRepresentationDictionary = _valueRepresentationDictionary
  property = _property
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
    
    elif element["name"] == "Sequence Delimitation Item":
      continue
    
    else:
      item.set(element["name"], element["value"])

  return sequence

func TranslateTagName(_tag : String) -> String:
  if not tagLibrary.has(_tag): return "-".repeat(50)
  return tagLibrary.get(_tag)['name']

func ReadElement() -> Dictionary[String, Variant]:
  var tag : String = property.transferSyntax.ReadTag()
  var valueRepresentation : String = property.transferSyntax.ReadValueRepresentation()
  var valueLength : int = property.transferSyntax.ReadValueLength()
  var value : Variant = property.transferSyntax.ReadValue(valueRepresentation, valueLength)

  var name : String = TranslateTagName(tag)
  return {
    "name": name,
    "value": value
  }