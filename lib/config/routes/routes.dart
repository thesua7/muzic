import 'package:flutter/material.dart';
import 'package:muzic/config/utils/presentation/pages/settings_page.dart';
import 'package:muzic/features/home/presentation/pages/home_page.dart';
// Adjust path as needed

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(HomePage()); // Modify as needed

      case '/settings':
        return _materialRoute(SettingsPage());

      default:
        return _materialRoute(HomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
