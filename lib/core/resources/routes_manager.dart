
import 'package:flutter/material.dart';


class RoutesManager {
  static const String splashScreen = '/';


}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      // case RoutesManager.splashScreen:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen());
      // case RoutesManager.layout:

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder:
          (_) => Scaffold(
            body: const Center(child: Text("No Route Found")),
          ),
    );
  }
}
