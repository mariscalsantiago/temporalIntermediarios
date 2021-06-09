import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


Future<bool> downloadTiendaEmpresarialApk(String url,String title, String type) async {
  Dio dio = Dio();
  var dir = await getApplicationDocumentsDirectory();
  String pathFile="${dir.path}/$title.$type";
  print(dir);
  try {
    await dio.download(url, pathFile);
    print("error:pathFile:: $pathFile");
    await OpenFile.open(pathFile);
    return true;

  } catch (e) {
    print("error:downloadAndShowFile: $e");
    return false;
  }
}