extends ValueRepresentation
class_name DecodeUnsignedLong

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength != 4: return "?" # should be fixed length 4 bytes
  return _reader.get_32()