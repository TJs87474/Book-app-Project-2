import 'package:flutter/foundation.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Map<String, String?>> _favorites = [];

  List<Map<String, String?>> get favorites => _favorites;

  void toggleFavorite(Map<String, dynamic> bookData) {
    final String? id = bookData['id']?.toString();
    final String? title = bookData['title']?.toString();
    final String? author = bookData['author']?.toString();
    final String? thumbnail = bookData['thumbnail']?.toString();
    final String? description = bookData['description']?.toString();

    final book = {
      'id': id,
      'title': title,
      'author': author,
      'thumbnail': thumbnail,
      'description': description,
    };

    final existingIndex = _favorites.indexWhere((item) => item['id'] == id);

    if (existingIndex != -1) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add(book);
    }

    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((book) => book['id'] == id);
  }
}
