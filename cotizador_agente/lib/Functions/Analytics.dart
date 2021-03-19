/*import 'dart:core';
import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = new FirebaseAnalytics();

Future<Null> sendTag(String tag) async {
  await analytics.logEvent(name: "$tag", parameters: <String, dynamic>{});
}

Future<Null> sendTagInteractionWithANamedParam(String tag,String paramName,String paramData) async {
  await analytics.logEvent(name: "$tag", parameters: <String, dynamic>{
    "$paramName" : "$paramData",
  });
}

Future<Null> setCurrentScreen(String screenName , String className) async {
  await analytics.setCurrentScreen(
      screenName: '$screenName' , screenClassOverride: '$className');
}

*/