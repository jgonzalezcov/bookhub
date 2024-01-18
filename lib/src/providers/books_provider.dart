import 'package:bookhub/src/helpers/database_helpers.dart';
import 'package:bookhub/src/models/book_model.dart';
import 'package:bookhub/src/services/book_service.dart';
import 'package:flutter/material.dart';

class BooksProvider with ChangeNotifier {
  late ScrollController _scrollController;
  List<Book> listBooks = [];
  Map<String, int> themePageCounters = {};
  Set<String> uniqueBookIds = {};
  int pageSize = 10;
  static const double scrollThreshold = 0.9;

  BooksProvider() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadBooks();
  }

  ScrollController get scrollController => _scrollController;

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * scrollThreshold) {
      _loadBooks();
    }
  }

  Future<void> reloadBooks() async {
    try {
      listBooks.clear();
      uniqueBookIds.clear();
      themePageCounters.clear();
      listBooks = [];
      await _loadBooks();
      _scrollController.jumpTo(0.0);
    } catch (e) {
      //MANEJO DE ERROR
    }
  }

  Future<void> _loadBooks() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();
      List<Map<String, dynamic>> themesData =
          await databaseHelper.getThemesNotNull();

      for (var themeData in themesData) {
        String theme = themeData['theme'];
        if (theme.isNotEmpty) {
          await _loadBooksForTheme(theme);
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    } catch (e) {
      // MANEJO DE ERROR
    }
  }

  Future<void> _loadBooksForTheme(String theme) async {
    try {
      int currentPage = themePageCounters[theme] ?? 1;
      List<Book> books =
          await BookService.getPaginatedBooks(theme, currentPage, pageSize);
      List<Book> newBooks = [...books]..shuffle();
      newBooks.removeWhere((book) => uniqueBookIds.contains(book.id));
      themePageCounters[theme] = currentPage + 1;
      if (newBooks.isNotEmpty) {
        listBooks.addAll(newBooks);
        uniqueBookIds.addAll(newBooks.map((book) => book.id));
      }
      notifyListeners();
    } catch (e) {
      // MANEJO DE ERROR
    }
  }

  void refresh() {
    notifyListeners();
  }
}
