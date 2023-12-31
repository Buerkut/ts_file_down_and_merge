import 'dart:convert';
import 'dart:io';

// args: ./res/ts_uri.json
Future<Map<String, String>> getUriInfo(String jspath) async {
  final content = await File(jspath).readAsString();
  return json.decode(content) as Map<String, String>;
}
