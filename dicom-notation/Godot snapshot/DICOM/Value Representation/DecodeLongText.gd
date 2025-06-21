extends ValueRepresentation
class_name DecodeLongText

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  return _reader.get_buffer(_valueLength).get_string_from_ascii()