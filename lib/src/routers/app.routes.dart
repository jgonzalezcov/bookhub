import 'package:flutter/material.dart';
import 'package:bookhub/src/screens/screens.dart' as screens;

class AppRoutes {
  static const initialRouter = 'Main';

  static Map<String, Widget Function(BuildContext)> routes = {
    'Main': (context) => const screens.MainScreen(),
    'Favorites': (context) => const screens.FavoritesScreen(),
    'Search': (context) => const screens.SearchScreen(),
    'Book': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final bookId = args['bookId'] as String;

      return screens.BookScreen(bookId: bookId);
    },
  };
}
