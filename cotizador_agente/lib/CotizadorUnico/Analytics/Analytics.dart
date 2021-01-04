/*
import 'package:firebase_analytics/firebase_analytics.dart';

final FirebaseAnalytics analytics = new FirebaseAnalytics();

Future<Null> sendPageAnalytics(String page) async {
  await analytics.logEvent(name: "$page", parameters: <String, dynamic>{});
}

Future<Null> sendTag(String tag) async {
  await analytics.logEvent(name: "$tag", parameters: <String, dynamic>{});
}

Future<Null> sendTagWithDynamicParams(String tag, Map<String, dynamic> parameters) async {
  await analytics.logEvent(name: "$tag", parameters: parameters);
}


Future<Null> sendTagInteractionWithANamedParam(String tag,String paramName,String paramData) async {
  await analytics.logEvent(name: "$tag", parameters: <String, dynamic>{
    "$paramName" : "$paramData",
  });
}

Future<Null> setCurrentScreen(String screenName , String className) async {
  await analytics.setCurrentScreen(
      screenName: '$screenName' , screenClassOverride: '$className');
}*/
