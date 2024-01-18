import 'package:bookhub/src/helpers/database_helpers.dart';
import 'package:stacked/stacked.dart';

class MainScreenModel extends BaseViewModel {
  late List<Map<String, dynamic>> books = [];
  bool _viewPreference = false;
  bool _isLoader = true;
  String _showMessage = '';

  bool get isLoader => _isLoader;
  String get showMessage => _showMessage;
  bool get viewPreference => _viewPreference;

  Future<void> updateViewPreference() async {
    _isLoader = true;
    final databaseHelper = DatabaseHelper();
    final count = await databaseHelper.countThemes();
    await Future.delayed(const Duration(seconds: 2), () {
      _viewPreference = count == 0;
      _isLoader = false;
    });

    notifyListeners();
  }

  void setViewPreferenceFalse() async {
    _isLoader = true;
    final databaseHelper = DatabaseHelper();
    final count = await databaseHelper.countThemes();
    if (count == 0) {
      _showMessage = 'Debe ingresar al menos una preferencia';

      await Future.delayed(const Duration(seconds: 2), () {
        _showMessage = '';
      });
      notifyListeners();
    } else {
      _viewPreference = false;

      notifyListeners();
    }
    await Future.delayed(const Duration(seconds: 2), () {
      _isLoader = false;
    });
    notifyListeners();
  }

  void setViewPreferenceTrue() async {
    _viewPreference = true;
    notifyListeners();
  }
}
