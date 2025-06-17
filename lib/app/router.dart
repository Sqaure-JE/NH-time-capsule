import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/create/create_screen.dart';
import '../presentation/screens/detail/detail_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String create = '/create';
  static const String detail = '/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case create:
        return MaterialPageRoute(builder: (_) => const CreateScreen());
      case detail:
        final capsuleId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(capsuleId: capsuleId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
} 