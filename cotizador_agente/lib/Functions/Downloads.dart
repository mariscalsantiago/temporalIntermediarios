import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';


Future<void> downloadAndShowPDFB64(String dataB64, String title) async {
  Uint8List bytes = base64.decode(dataB64);
  String dir = (await getApplicationDocumentsDirectory()).path;
  File file = File("$dir/" + "$title"+".pdf");
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

Future<Uint8List> getPDFB64dataForm(String data) async {
  Uint8List bytes = base64.decode(data);
  return bytes;
}

Future<void> downloadAndShowFile(String url,String title, String type ) async {
  Dio dio = Dio();
  var dir = await getApplicationDocumentsDirectory();
  String pathFile="${dir.path}/$title$type";
  print(dir);
  try {
    await dio.download(url, pathFile);
  } catch (e) {
    print(e);
  }
  print(pathFile);
  OpenFile.open(pathFile);
}

Future<Map> downloadOnGalleryMultipleImages(List pathList) async {
  Map response;
  if(Platform.isAndroid){
    if(await ShareExtend.getPermissions()){
      Dio dio = Dio();
      Directory pathDirectory = await getExternalStorageDirectory();
      String pathGalleryGNP="${pathDirectory.path.substring(0,pathDirectory.path.indexOf("/Android/data/"))}/APPContrata/";
      Directory directoryGalleryGNP = new Directory(pathGalleryGNP);
      if(!await directoryGalleryGNP.exists()){
        try {
          directoryGalleryGNP.create();
        } catch (e) {
          print(e);
        }
      }
      List<String> fileList  = [] ;
      if(await directoryGalleryGNP.exists()){
        String directory=directoryGalleryGNP.path;
        for(String i in pathList){
          String fileName = DateTime.now().toString();
          String filePath = "$directory$fileName.png";
          fileList.add(filePath);
          try {
            await dio.download(i, filePath ,
                onReceiveProgress: (rec, total) { });
          } catch (e) {
            print(e);
          }
        }
      }
      int countFiles=0;
      for(String i in fileList){
        if(await File(i).exists()){
          countFiles=countFiles+1;
        }
      }
      if(countFiles>0){
        if(pathList.length-countFiles==0){
          response = {
            "status" : "Succes",
            "description" : "El contenido se descargó correctamente"
          };
        }else{
          response = {
            "status" : "Succes",
            "description" : "Faltaron archivos (${pathList.length-countFiles})"
          };
        }
      }else{
        response = {
          "status" : "Failed",
          "description" : "No se descarganron las imágenes"
        };
      }

    }else{
      response = {
        "status" : "Failed",
        "description" : "Faltan permisos"
      };
    }
  }else{

    List docsList =  [];
    for(int i=0;i<pathList.length;i++){
      var pathFile = await downloadFileShare(pathList[i], "img$i",".png");
      docsList.add(pathFile);
      print("pathFile $i ===> "+pathFile);
    }
    print("***docsList===> "+docsList.toString());

    print("downloadOnGalleryMultipleImages");
    ShareExtend.downloadOnGalleryMultipleImages(docsList);
    response = {
      "status" : "Succes",
      "description" : "iOS"
    };
  }
  if(response == null){
    response ={
      "status" : "Failed",
      "description" : "Error inesperado"
    };
  }
  print(response);
  return response;
}

Future<String> downloadFileShare(String url,String title, String type ) async {
  Dio dio = Dio();
  var dir = await getApplicationDocumentsDirectory();
  String pathFile="${dir.path}/$title$type";
  print("dir=> $dir");
  try {
    await dio.download(url, pathFile ,
        onReceiveProgress: (rec, total) {
          print("rec *** $rec");
          print("total *** $total");
        });
    print("return**********");
    print("pathFile********** $pathFile");
    return pathFile;
  } catch (e) {
    print(e);
    return "";
  }
  //OpenFile.open(pathFile);
}


Future<void> downloadFile(String url,String title, String type ) async {
  Dio dio = Dio();
  var dir = await getApplicationDocumentsDirectory();
  String pathFile="${dir.path}/$title$type";
  print(dir);
  try {
    await dio.download(url, pathFile ,
        onReceiveProgress: (rec, total) {
        });
  } catch (e) {
    print(e);
  }
  //OpenFile.open(pathFile);
}