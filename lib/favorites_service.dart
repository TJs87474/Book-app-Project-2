import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  /// Adds a book to the user's favorites with default reading status
  Future<void> addFavorite(Map<String, dynamic> bookData) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final favoritesRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites');

    final bookId = bookData['id'];

    // Use the book ID as the document ID
    await favoritesRef.doc(bookId).set({
      'title': bookData['title'],
      'author': bookData['author'],
      'description': bookData['description'],
      'thumbnail': bookData['thumbnail'],
      'readingStatus': 'Want to Read', // Default status
    });
  }

  /// Removes a favorite book by its document ID
  Future<void> removeFavorite(String favoriteId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(favoriteId)
        .delete();
  }

  /// Updates the reading status for a given book
  Future<void> updateReadingStatus(String bookId, String newStatus) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(bookId)
        .update({'readingStatus': newStatus});
  }

  /// Returns a stream of favorite books with their details
  Stream<List<Map<String, dynamic>>> getFavorites() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'title': data['title'],
                'author': data['author'],
                'description': data['description'],
                'thumbnail': data['thumbnail'],
                'readingStatus': data.containsKey('readingStatus')
                    ? data['readingStatus']
                    : 'Want to Read',
              };
            }).toList());
  }
}
