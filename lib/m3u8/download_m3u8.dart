import 'dart:io';
import 'package:ts/file/write_as_stream.dart';

// Download m3u8 file first。
Future<File> downloadM3u8(Uri url, String path) async {
  final File file;
  final client = HttpClient();
  try {
    final request = await client.getUrl(url);
    final response = await request.close();
    file = await writeAsStream(path, response);
  } finally {
    client.close();
  }

  return file;
}
