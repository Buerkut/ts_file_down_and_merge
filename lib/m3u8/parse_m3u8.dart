import 'dart:convert';
import 'dart:io';

Future<List<String>> parseM3u8(File m3u8File) async {
  final lines = m3u8File
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  final tspths = <String>[];
  await for (var line in lines) {
    if (line.startsWith('#')) continue;
    tspths.add(line);
  }
  return tspths;
}
