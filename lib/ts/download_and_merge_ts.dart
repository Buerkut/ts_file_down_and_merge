// download and merge ts files into one in concurrency

import 'dart:io';

import 'package:ts/concurrency/tasks_split.dart';
import 'package:ts/file/merge_files_into_one.dart';
import 'package:ts/file/write_as_stream.dart';

// final dirpath = './lib/http/downloads/gear2/ts/';
void downloadAndMerge(
    Map<String, String> uriJson, List<String> tspths, String dirpath) async {
  Future<File> downmerge(int i, Iterable<String> slice) async {
    final files = <Future<File>>[], client = HttpClient();
    try {
      for (final fpth in slice) {
        print('$fpth download start');
        final url =
            Uri.http(uriJson['authority']!, '${uriJson['unencodedPath']}$fpth');
        final request = await client.getUrl(url);
        final response = await request.close();
        // Don't use await here. Or else it will block the loop.
        final file = writeAsStream('$dirpath$fpth', response);
        files.add(file);
      }
    } on Error catch (e) {
      print('Error: $e');
    } finally {
      client.close();
    }

    return mergeFilesIntoOne(await files.wait, '$dirpath/merged/merged$i.ts');
  }

  final isolateNum = 8;
  final tfs = await conprocess(tspths, downmerge, isolateNum).wait;

  // 将多个isolate合并的临时文件再次合并为最终文件，完成后删除临时文件。
  final merged = await mergeFilesIntoOne(tfs, '$dirpath/merged/merged.ts');
  for (final f in tfs) {
    f.delete();
  }
  print(
      'All download and merged task finished. The merged file is ${merged.path}');
}
