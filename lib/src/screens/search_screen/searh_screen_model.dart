import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:bookhub/src/services/book_service.dart';
import 'package:bookhub/src/models/book_model.dart';

class SearchScreenModel extends BaseViewModel {
  final TextEditingController _searchController = TextEditingController();
  final List<Book> _books = [];
  int _startIndex = 0;
  bool _isLoading = false;
  final Set<String> _uniqueBookIds = <String>{};

  late ScrollController _scrollController;

  TextEditingController get searchController => _searchController;
  List<Book> get books => _books;
  bool get isLoading => _isLoading;
  set scrollController(ScrollController controller) {
    _scrollController = controller;
    _scrollController.addListener(_scrollListener);
  }

  Set<String> get uniqueBookIds => _uniqueBookIds;

  ScrollController get scrollController => _scrollController;

  SearchScreenModel() {
    _scrollController = ScrollController();
    setBusy(true);
    _buscarLibros(_searchController.text);
  }

  set startIndex(int value) {
    _startIndex = value;
  }

  void _scrollListener() {
    if (_isScrollCloseToBottom() && !_isLoading) {
      _buscarLibros(_searchController.text);
    }
  }

  bool _isScrollCloseToBottom() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const percentage = 0.8;

    return currentScroll > maxScroll * percentage;
  }

  Future<void> _buscarLibros(String query) async {
    if (_isLoading) {
      return;
    }

    try {
      _isLoading = true;

      final newBooks = await BookService.searchBooks(query, _startIndex, 30);
      newBooks.removeWhere((book) => !_uniqueBookIds.add(book.id));

      _books.addAll(newBooks);
      _startIndex += 30;
    } catch (e) {
      // MANEJAR ERROR
    } finally {
      _isLoading = false;
      setBusy(false);
    }
  }

  void buscarLibros() {
    _startIndex = 0;
    _books.clear();
    _uniqueBookIds.clear();
    _buscarLibros(_searchController.text);
  }
}
