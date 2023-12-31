import 'dart:io';

import 'package:ts/concurrency/tasks_split.dart';
import 'package:ts/file/merge_files_into_one.dart';

// The dir path of ts files to be merged.
// final dirpath = './lib/http/downloads/gear2/ts/';
void mergeTsFiles(List<String> tspths, String dirpath) async {
  final files = getFiles(dirpath, tspths);
  final isolateNum = 4;
  final tfs = await conprocess(files, _merge, isolateNum).wait;

  // Merge temporary files into the final file and then delete them after completion。
  final merged = await mergeFilesIntoOne(tfs, '$dirpath/merged/merged.ts');
  for (final tf in tfs) {
    tf.delete();
  }
  print('All files are merged. The merged file is ${merged.path}');
}

List<File> getFiles(String dirpath, List<String> tspths) =>
    tspths.map((tspth) => File('$dirpath$tspth')).toList();

Future<File> _merge(int i, Iterable<File> parts) async {
  final outpath = '${parts.first.parent}/merged/merged$i.ts';
  var merged = await mergeFilesIntoOne(parts, outpath);
  return merged;
}
