extends ValueRepresentation
class_name DecodeAgeString

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  # can contain mulitple value matching
  # nnnD, nnnW, nnnM, nnnY (days, weeks, months, years)
  if _valueLength % 4 != 0: return "" # 4 bytes fixed

  var stream : String = _reader.get_buffer(_valueLength).get_string_from_ascii()
  if not stream.contains("\\"): return stream

  var multipleValue : PackedStringArray = stream.split("\\")
  for value in multipleValue:
    if value.length() != 4: return ""
  
  return stream