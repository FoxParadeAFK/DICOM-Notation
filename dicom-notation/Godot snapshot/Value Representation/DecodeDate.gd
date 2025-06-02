extends ValueRepresentation
class_name DecodeDate

var month : Dictionary[String, String] = {
  "01": "January",
  "02": "February",
  "03": "March",
  "04": "April",
  "05": "May",
  "06": "June",
  "07": "July",
  "08": "August",
  "09": "September",
  "10": "October",
  "11": "November",
  "12": "December"
}

# can be either a single date or a duration range between two
func Translate(_reader : FileAccess, _valueLength : int) -> Variant:
  if _valueLength > 18: return "?" # range matching maximum 18 bytes
  if _valueLength == 8: return FormatDate(_reader.get_buffer(_valueLength).get_string_from_ascii())

  var duration : PackedStringArray = _reader.get_buffer(_valueLength).get_string_from_ascii().split("-")
  var start : String = FormatDate(duration[0])
  var end : String = FormatDate(duration[1])
  return "%s - %s" % [start, end]

func FormatDate(date : String) -> String:
  if date.length() != 8: return "?" # individual date 8 bytes fixed
  var YYYY : String = date.substr(0, 4)
  var MM : String = month.get(date.substr(4, 2))
  var DD : String = date.substr(6, 2)
  return "%s %s, %s" % [DD, MM, YYYY]