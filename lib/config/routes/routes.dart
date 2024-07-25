import 'package:flutter/material.dart';
import 'package:muzic/config/utils/presentation/pages/settings_page.dart';
import 'package:muzic/features/home/domain/entities/song.dart';
import 'package:muzic/features/home/presentation/pages/home_page.dart';
import 'package:muzic/features/home/presentation/pages/song_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _slidePageRoute(const HomePage());

      case '/settings':
        return _slidePageRoute(const SettingsPage());

      case '/song':
        if (settings.arguments is Map) {
          final args = settings.arguments as Map<String, dynamic>;
          if (args.containsKey('songs') && args.containsKey('currentIndex')) {
            final songs = args['songs'] as List<Song>;
            final currentIndex = args['currentIndex'] as int;
            return _slidePageRoute(
                SongPage(songs: songs, currentIndex: currentIndex));
          } else {
            return _slidePageRoute(const HomePage());
          }
        } else {
          return _slidePageRoute(const HomePage());
        }

      default:
        return _slidePageRoute(const HomePage());
    }
  }

  static Route<dynamic> _slidePageRoute(Widget view) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end);
        var curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        var offsetAnimation = tween.animate(curvedAnimation);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
