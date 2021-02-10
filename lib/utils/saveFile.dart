import 'dart:io' as Io;
import 'package:path_provider/path_provider.dart';
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
  try {
    var dir = await getExternalStorageDirectory();
    var testdir =
        await Io.Directory('${dir.path}/Wrotto').create(recursive: true);
    return new Io.File(
        '${testdir.path}/${DateTime.now().toUtc().toIso8601String()}.json')
      ..writeAsStringSync(json);
  } catch (e) {
    print(e);
    return null;
  }
}
