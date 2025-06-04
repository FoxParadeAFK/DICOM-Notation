extends ValueRepresentation
class_name DecodeOtherByteString

#NOTE - i don't know if I should hex encode or not
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""
  var stream : PackedStringArray
  for byte in range(_valueLength): stream.append("%s" % _reader.get_8())

  return stream