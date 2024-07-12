import 'package:flutter/material.dart';
import 'package:muzic/config/utils/presentation/pages/settings_page.dart';
import 'package:muzic/features/home/presentation/pages/home_page.dart';
// Adjust path as needed

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const HomePage()); // Modify as needed

      case '/settings':
        return _materialRoute(const SettingsPage());

      default:
        return _materialRoute(const HomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
