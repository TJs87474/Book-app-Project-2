import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FavoritesProvider.dart';
import 'BookDetailsPage.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, _) {
          final favoriteBooks = provider.favorites;
          return favoriteBooks.isEmpty
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
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: const Color.fromARGB(255, 0, 0, 0)),
                        onPressed: () {
                          provider.toggleFavorite(book);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                              title: book['title'] ?? 'No Title',
                              author: book['author'] ?? 'Unknown',
                              description: book['description'] ?? 'No description available.',
                              imageUrl: book['thumbnail'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
