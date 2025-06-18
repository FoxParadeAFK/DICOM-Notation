extends ValueRepresentation
class_name DecodeSignedShort

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength != 2: return ""
  var stream : int = _reader.get_16()

  var significant : int = stream & 0x8000
  var magnitude : int = stream & 0x7FFF

  return magnitude - significant