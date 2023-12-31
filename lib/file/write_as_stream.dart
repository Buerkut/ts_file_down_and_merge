import 'dart:io';

Future<File> writeAsStream(String fpth, Stream<List<int>> stream) async {
  final file = await File(fpth).create(recursive: true);
  final sink = file.openWrite();
  try {
    await sink.addStream(stream);
    await sink.flush();
  } on Error catch (e) {
    print('Error: $e');
  } finally {
    sink.close();
  }
  return file;
}
