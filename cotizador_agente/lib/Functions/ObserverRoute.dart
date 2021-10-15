import 'package:flutter/material.dart';
import '../main.dart';

class ObserverRoute extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic> route) {
    screenName = route.settings.name;
    print(' ============ >> screenName $screenName');
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    print('ObserverRoute: didPush ');
    if (route is PageRoute) {
      // print(' didPush to: $route ');
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('ObserverRoute: didReplace ');
    if (newRoute is PageRoute) {
      // print(' didReplace from $oldRoute to $newRoute');
       _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      print('ObserverRoute: didPop ');
      _sendScreenView(previousRoute);
    }
  }
}
