extends ValueRepresentation
class_name DecodePersonName

#FIXME - we don't have a valid example of a person name
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""
  return _reader.get_buffer(_valueLength).get_string_from_ascii()