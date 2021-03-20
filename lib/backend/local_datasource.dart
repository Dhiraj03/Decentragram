import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalDataSource {
  //In case of text-based posts, a temporary file is created in the temp dir, and this file is uploaded to IPFS
  Future<File> storeFile(String data) async {
    var dir = await getTemporaryDirectory();
    print(data);
    File tempFile = File('${dir.path}/temp.txt');
    await tempFile.writeAsString(data);
    return tempFile;
  }
}
