import 'dart:io';

Future<File> mergeFilesIntoOne(Iterable<File> files, String outpath) async {
  final output = await File(outpath).create(recursive: true);
  final sink = output.openWrite();
  try {
    for (final f in files) {
      await sink.addStream(f.openRead());
    }
  } catch (e) {
    print('Error: $e');
  } finally {
    sink.close();
  }
  return output;
}
