import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, String?>> _favorites = [];

  List<Map<String, String?>> get favorites => _favorites;

  void toggleFavorite(Map<String, String?> book) {
    final existing = _favorites.indexWhere((b) => b['id'] == book['id']);
    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      _favorites.add(book);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((b) => b['id'] == id);
  }
}
