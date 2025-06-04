extends ValueRepresentation
class_name DecodeOtherWordString

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""

  var value : PackedInt64Array
  for word in range(0, _valueLength, 2):
    value.append(_reader.get_16())
  
  return value