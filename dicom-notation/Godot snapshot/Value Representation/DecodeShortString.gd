extends ValueRepresentation
class_name DecodeShortString

#FIXME - 16 char maximum - assuming 8 bit character set
#FIXME - add 16 char checking
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength == 0: return ""
  # default is iso/iec 646 however it appears to be very similar to ascii 
  return _reader.get_buffer(_valueLength).get_string_from_ascii()