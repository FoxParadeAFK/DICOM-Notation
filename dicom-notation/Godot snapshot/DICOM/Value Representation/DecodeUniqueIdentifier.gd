extends ValueRepresentation
class_name DecodeUniqueIdentifier

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""
  if _valueLength > 64: return "?"
  return _reader.get_buffer(_valueLength).get_string_from_ascii()