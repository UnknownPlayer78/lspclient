Map<String, dynamic> parseHeader(data) {
  var entries = <String, dynamic>{};
  data.split('\r\n').forEach((String entry) {
    var pair = entry.split(':');

    var value = pair[1];
    var key = pair[0];
    entries[key] = value;
  });
  return entries;
}
