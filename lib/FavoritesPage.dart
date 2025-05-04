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
          .snapshots();
    }
  }

  Future<void> removeFavorite(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(bookId)
            .delete();
      } catch (e) {
        print('Error removing favorite: $e');
      }
    }
  }

  Future<void> updateReadingStatus(String bookId, String status) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favorites')
            .doc(bookId)
            .update({'readingStatus': status});
      } catch (e) {
        print('Error updating reading status: $e');
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
              final id = favorite.id;
              final data = favorite.data() as Map<String, dynamic>;

              final title = data['title'];
              final author = data['author'];
              final description = data['description'];
              final thumbnail = data['thumbnail'];

              // Safely handle missing 'readingStatus'
              final readingStatus = data.containsKey('readingStatus')
                  ? data['readingStatus']
                  : 'Want to Read';

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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author),
                    SizedBox(height: 4),
                    DropdownButton<String>(
                      value: readingStatus,
                      onChanged: (newStatus) {
                        if (newStatus != null) {
                          updateReadingStatus(id, newStatus);
                        }
                      },
                      items: ['Want to Read', 'Currently Reading', 'Finished']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    removeFavorite(id);
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
