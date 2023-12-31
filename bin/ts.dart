import 'package:ts/m3u8/download_m3u8.dart';
import 'package:ts/m3u8/parse_m3u8.dart';
import 'package:ts/ts/download_ts.dart';
import 'package:ts/ts/merge_ts.dart';
// import 'package:ts/ts/download_and_merge_ts.dart';
import 'package:ts/uri_json/decode_json.dart';

// 1、解析url-json文件
// 2、从网上获取m3u8文件
// 3、解析m3u8，并多线程下载
// 4、解析m3u8，并多线程合并
// 5、或者将3、4合并执行，即：解析m3u8文件，进行多线程下载及合并
void main(List<String> arguments) async {
  // print('Hello world: ${ts.calculate()}!');
  final jspath = './res/ts_uri.json';
  final uriJson = await getUriInfo(jspath);
  final url = Uri.http(uriJson['authority']!,
      '${uriJson['unencodedPath']}${uriJson['m3u8Path']}');

  final m3u8Path = './res/prog_index.m3u8';
  final m3u8 = await downloadM3u8(url, m3u8Path);

  final tspths = await parseM3u8(m3u8);
  final dirpath = './output/ts/';
  await downloadTsFiles(uriJson, tspths, dirpath);
  mergeTsFiles(tspths, dirpath);

  // or do download and merge together.
  // downloadAndMerge(uriJson, tspths, dirpath);
}
