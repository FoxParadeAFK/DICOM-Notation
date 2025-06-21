extends ValueRepresentation
class_name DecodeDecimalString

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""

  var stream : String = _reader.get_buffer(_valueLength).get_string_from_ascii()
  var multipleValue : PackedStringArray = stream.split("\\")
  for value in multipleValue:
    if value.length() > 16: return "?" # maximum length 16 bytes
  
  return multipleValue