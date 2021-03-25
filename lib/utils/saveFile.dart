import 'dart:io' as Io;
// import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> saveJson(String json) async {
  await new Future.delayed(new Duration(seconds: 1));

  if (await Permission.storage.request().isGranted) {
    var res = await saveJsonString(json);
    return res.path;
  }
  return null;
}

Future<Io.File> saveJsonString(String json) async {
  // try {
  // var dir = await getApplicationDocumentsDirectory();
  var dir = Io.Directory('/storage/emulated/0');
  // var dir = await DownloadsPathProvider.downloadsDirectory;
  var testdir =
      await Io.Directory('${dir.path}/Wrotto').create(recursive: true);
  return new Io.File(
      '${testdir.path}/${DateTime.now().toUtc().toIso8601String()}.json')
    ..writeAsStringSync(json);
  // } catch (e) {
  //   print(e);
  //   return null;
  // }
}

// Future<String> _createFolder(String cow) async {
//   final folderName = cow;
//   final path = Directory("/storage/emulated/0/$folderName");
//   var status = await Permission.storage.status;
//   if (!status.isGranted) {
//     await Permission.storage.request();
//   }
//   if ((await path.exists())) {
//     return path.path;
//   } else {
//     path.create();
//     return path.path;
//   }
// }
