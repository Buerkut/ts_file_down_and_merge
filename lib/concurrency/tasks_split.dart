// 尝试切分任务，然后以并发的形式执行。
import 'dart:async';
import 'dart:isolate';

import 'package:ts/list/list_apis.dart';

List<Future<R>> conprocess<R, T>(
    List<T> tasks, Future<R> Function(int i, Iterable<T> slice) compute,
    [int isolateNum = 8]) {
  final results = <Future<R>>[];
  var i = 0, seg = tasks.length ~/ isolateNum;
  while (i < isolateNum - 1) {
    // Important: can't use await here.
    results.add(
        Isolate.run(() => compute(i, tasks.slice(seg * i, seg * (i + 1)))));
    i++;
  }
  results.add(Isolate.run(() => compute(i, tasks.slice(seg * i))));
  return results;
}
