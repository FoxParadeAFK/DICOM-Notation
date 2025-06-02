extends ValueRepresentation
class_name DecodeCodeString

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  var stream : String = _reader.get_buffer(_valueLength).get_string_from_ascii()
  var mulitpleValue : PackedStringArray = stream.split("\\")
  for value in mulitpleValue:
    if value.length() > 16: return "?" # maximum length 16 bytes
  
  return mulitpleValue
