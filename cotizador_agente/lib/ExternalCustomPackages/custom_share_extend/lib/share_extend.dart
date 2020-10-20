/// A flutter plugin to share text, image, file with system ui.
/// It is compatible with both andorid and ios.
///
///
/// A open source authorized by zhouteng [https://github.com/zhouteng0217/ShareExtend](https://github.com/zhouteng0217/ShareExtend).

import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui';

/// Plugin for summoning a platform share sheet.
class ShareExtend {
  /// [MethodChannel] used to communicate with the platform side.
  static const MethodChannel _channel = const MethodChannel('custom_share_extend');

  /// method to share with system ui
  ///  It uses the ACTION_SEND Intent on Android and UIActivityViewController
  /// on iOS.
  /// type  "text", "image" ,"file"
  ///
  static Future<void> share(List<String> text, String type,
      {Rect sharePositionOrigin}) {
    assert(text != null);
    assert(text.isNotEmpty);
    final Map<String, dynamic> params = <String, dynamic>{
      'list': text,
      'type': type
    };

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }

    return _channel.invokeMethod('share', params);
  }

  static Future<String> shareMulti(String title,List fileList, String type,
      {Rect sharePositionOrigin}) async {
    assert(title != null);
    assert(title.isNotEmpty);
    assert(fileList != null);
    assert(fileList.isNotEmpty);
    final Map<String, dynamic> params = <String, dynamic>{
      'text': "$title",
      'fileList': fileList,
      'type': type
    };
    print("shareMulti");
    print(params);

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      print("shareMulti");
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }
    return _channel.invokeMethod('share_multi', params);
  }


  static Future<void> downloadOnGalleryMultipleImages(List fileList) async {
    assert(fileList != null);
    assert(fileList.isNotEmpty);
    final Map<String, dynamic> params = <String, dynamic>{
      'fileList': fileList
    };
    await _channel.invokeMethod('download_gallery_multi', params);
  }

  static Future<bool> getPermissions() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    bool permissions = await _channel.invokeMethod("get_permissions", params);
    return permissions;
  }

}
