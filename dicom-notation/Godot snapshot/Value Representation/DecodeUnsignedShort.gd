extends ValueRepresentation
class_name DecodeUnsignedShort

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength % 2 != 0: return "?" # fixed length 2 bytes

  var sequence : PackedInt32Array
  for value in range(0, _valueLength, 2):
    sequence.append(_reader.get_16())
  
  return sequence