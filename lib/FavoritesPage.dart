import 'package:bookapp/BookDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Stream<QuerySnapshot> _favoritesStream;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _favoritesStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .snapshots(); // Listen for real-time updates
    }
  }

  // Function to remove a favorite
  Future<void> removeFavorite(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Remove the book from Firestore favorites collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(bookId) // Use the book's unique ID
            .delete();
      } catch (e) {
        print('Error removing favorite: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Favorites')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _favoritesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites added yet.'));
          }

          final favorites = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final id = favorite.id; // This is the document ID, which should be the unique book ID
              final title = favorite['title'];
              final author = favorite['author'];
              final description = favorite['description'];
              final thumbnail = favorite['thumbnail'];

              return ListTile(
                leading: thumbnail != null
                    ? Image.network(thumbnail, width: 50, fit: BoxFit.cover)
                    : Icon(Icons.menu_book_outlined, size: 50),
                title: GestureDetector(
                  child: Text(
                    title,
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(
                          title: title,
                          author: author,
                          description: description,
                          imageUrl: thumbnail,
                        ),
                      ),
                    );
                  },
                ),
                subtitle: Text(author),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle, color: const Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () {
                    removeFavorite(id); // Pass the book's unique ID to remove it
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
