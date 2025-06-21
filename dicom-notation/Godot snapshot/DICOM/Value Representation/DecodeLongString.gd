extends ValueRepresentation
class_name DecodeLongString

#FIXME - 64 char maximum - assuming 8 bit character set
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""
  var stream : String = _reader.get_buffer(_valueLength).get_string_from_ascii()
  var mulitpleValue : PackedStringArray = stream.split("\\")
  for value in mulitpleValue:
    if value.length() > 64: return "?" # maximum length 64 char

  return mulitpleValue