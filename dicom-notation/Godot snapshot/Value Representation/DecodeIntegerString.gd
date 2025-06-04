extends ValueRepresentation
class_name DecodeIntegerString

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength > 12: return "?" # maximum length 12 bytes

  return _reader.get_buffer(_valueLength).get_string_from_ascii()