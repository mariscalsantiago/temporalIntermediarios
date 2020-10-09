
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsHandler {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  AnalyticsHandler() {
    analytics.setAnalyticsCollectionEnabled(true);
  }

  static void setScreenName(String name) {
    analytics.setCurrentScreen(screenName: name);
  }

  static void logEvent({String name, Map<String, dynamic> parameters}) {
    analytics.logEvent(name: name, parameters: parameters);
  }

  static void addUserProperty({String name, String value}) {
    analytics.setUserProperty(name: name, value: value);
  }

}