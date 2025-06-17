extends ValueRepresentation
class_name DecodeSequenceOfItems

var transferSyntaxUID : TransferSyntaxUID
var sequence : Array[Dictionary] 
var item : Dictionary[String, Variant]
var element : Dictionary[String, Variant]

func _init(_transferSyntaxUID : TransferSyntaxUID) -> void: 
  transferSyntaxUID = _transferSyntaxUID

#FIXME - we only have unknown length. need to factor in the option of defined length
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  while element.get("name", "") != "Sequence Delimitation Item":
    var header : Dictionary[String, Variant] = DeduceTag()
    element = ReadElement(header["tag"], header["name"], header["valueLength"])

    if element["name"] == "Item":
      item.clear()
      continue
    
    elif element["name"] == "Item Delimitation Item":
      sequence.append(item.duplicate())
      continue
    
    elif element["name"] == "Sequence Delimitation Item": continue
    item.set(element["name"], element["value"])

  return sequence

func DeduceTag() -> Dictionary[String, Variant]:
  var tag : String = transferSyntaxUID.transferSyntax.ReadTag()
  var name : String = transferSyntaxUID.transferSyntax.TranslateTagName(tag)
  var valueLength : int = transferSyntaxUID.transferSyntax.ReadItemLength(name)

  return { "tag": tag, "name": name, "valueLength": valueLength }

func ReadElement(_tag : String, _name : String, _valueLength : int) -> Dictionary[String, Variant]:
  if _name in ["Item", "Item Delimitation Item", "Sequence Delimitation Item"]: return { "name": _name }

  var valueRepresentation : String = transferSyntaxUID.transferSyntax.ReadValueRepresentation()
  var valueLength : int = transferSyntaxUID.transferSyntax.ReadValueLength()
  var value : Variant = transferSyntaxUID.transferSyntax.ReadValue(valueRepresentation, valueLength)

  return { "tag": _tag, "name": _name, "valueLength": valueLength, "valueRepresentation": valueRepresentation, "value": value }