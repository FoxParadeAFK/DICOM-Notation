extends ValueRepresentation
class_name DecodeUnknown

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  # return "!! %s" % _reader.get_buffer(_valueLength)
  _reader.get_buffer(_valueLength)
  return ""