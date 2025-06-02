extends ValueRepresentation
class_name DecodeShortString

#NOTE - dependent on tag 0008 0005 but we'll assume ascii 
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  #TODO - 16 chars fix
  return _reader.get_buffer(_valueLength).get_string_from_ascii()