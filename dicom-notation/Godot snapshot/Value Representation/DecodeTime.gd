extends ValueRepresentation
class_name DecodeTime

func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength > 28: return "?" # range maximum length 28 bytes
  if _valueLength <= 16: return FormatTime(_reader.get_buffer(_valueLength).get_string_from_ascii())

  return "?"

func FormatTime(time : String) -> String:
  var HH : String = FormatIntegral(time.substr(0, 2), "Hours")
  var MM : String = FormatIntegral(time.substr(2, 2), "Minutes")
  var SS : String = FormatSecond(time.substr(4, 2), time.substr(6, 1), "Seconds")
  var FFFFFF : String = FormatIntegral(time.substr(7, 6), "Seconds")

  return "%s %s %s %s" % [HH, MM, SS, FFFFFF]

func FormatIntegral(integral : String, padding : String) -> String:
  if integral.length() != 2: return ""
  return "%s %s" % [integral, padding]

func FormatSecond(second : String, fractionalPoint : String, padding : String) -> String:
  if second.length() != 2: return ""
  if fractionalPoint.length() != 1 or fractionalPoint != ".": return "%s %s" % [second, padding] # there is no fractional section
  return "%s%s" % [second, fractionalPoint] # no padding if there is a fractional point

func FormatFractional(fractional : String, padding : String) -> String:
  if fractional.length() <= 0 or fractional.length() > 6: return ""
  return "%s %s" % [fractional, padding]

