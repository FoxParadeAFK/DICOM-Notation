extends ValueRepresentation
class_name DecodeShortString

#NOTE - dependent on tag 0008 0005 but we'll assume ascii 
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  # default is iso/iec 646 however it appears to be very similar to ascii 
  return _reader.get_buffer(_valueLength).get_string_from_ascii()