import 'dart:io';

// Download m3u8 file first。
Future<File> downloadM3u8(Uri url, String path) async {
  final file = await File(path).create(recursive: true);
  final sink = file.openWrite();
  final client = HttpClient();
  try {
    final request = await client.getUrl(url);
    final response = await request.close();
    await sink.addStream(response);
    await sink.flush();
  } finally {
    client.close();
    sink.close();
  }
  return file;
}
