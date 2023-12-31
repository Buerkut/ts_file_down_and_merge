import 'dart:io';

import 'package:ts/concurrency/tasks_split.dart';
import 'package:ts/file/write_as_stream.dart';

// The parent dir of ts files.
// final dirpath = './lib/http/downloads/gear2/ts/';
Future<void> downloadTsFiles(
    Map<String, String> uriJson, List<String> tspths, String dirpath) async {
  Future<void> download(int i, Iterable<String> fpthSlice) async {
    final client = HttpClient();
    try {
      for (final fpth in fpthSlice) {
        print('$fpth download start');
        final url =
            Uri.http(uriJson['authority']!, '${uriJson['unencodedPath']}$fpth');
        final request = await client.getUrl(url);
        final response = await request.close();
        writeAsStream('$dirpath$fpth', response); // don't need await.
      }
    } on Error catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }
  }

  final isolateNum = 8;
  conprocess(tspths, download, isolateNum);
}
