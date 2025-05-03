import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  // This is where you would pass the favorite books list
  final List<Map<String, String?>> favoriteBooks;

  FavoritesPage({required this.favoriteBooks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favoriteBooks.isEmpty
          ? Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return ListTile(
                  leading: book['thumbnail'] != null
                      ? Image.network(book['thumbnail']!, width: 50, fit: BoxFit.cover)
                      : Icon(Icons.menu_book_outlined, size: 50),
                  title: Text(book['title'] ?? 'No Title'),
                  subtitle: Text(book['author'] ?? 'Unknown'),
                );
              },
            ),
    );
  }
}
