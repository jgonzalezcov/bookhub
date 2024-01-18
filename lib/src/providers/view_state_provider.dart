import 'package:flutter/material.dart';

class ViewStateProvider with ChangeNotifier {
  String _topicSelect = 'Home';
  String _vScreen = '';
  bool _reloadFavorite = false;

  String get topicSelect => _topicSelect;

  void setSelectedTopic(String topic) {
    _topicSelect = topic;
    notifyListeners();
  }

  String get viewScreen => _vScreen;

  void setViewScreen(String textScreen) {
    _vScreen = textScreen;
    notifyListeners();
  }

  bool get reloadFavorite => _reloadFavorite;

  void setReloadFavorite(bool stateReload) {
    _reloadFavorite = stateReload;
    notifyListeners();
  }
}
