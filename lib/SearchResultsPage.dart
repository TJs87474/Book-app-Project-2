import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'BookDetailsPage.dart';

class SearchResultsPage extends StatefulWidget {
  final String query;

  SearchResultsPage({required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<dynamic> _books = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=${widget.query}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _books = data['items'] ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load books');
    }
  }

  // Add book to user's favorites in Firestore
  Future<void> addFavoriteToFirestore(Map<String, String?> bookData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get user's favorites collection in Firestore
    final userFavorites = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    // Check if the book is already in favorites
    final favoriteQuery = await userFavorites.where('id', isEqualTo: bookData['id']).get();
    if (favoriteQuery.docs.isEmpty) {
      // Add the book if not already in favorites
      await userFavorites.add(bookData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${bookData['title']} added to favorites!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${bookData['title']} is already in favorites!')),
      );
    }
  }

  // Check if the book is already in favorites
  Future<bool> isFavorite(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final userFavorites = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites');

    final favoriteQuery = await userFavorites.where('id', isEqualTo: bookId).get();
    return favoriteQuery.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results for "${widget.query}"')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _books.isEmpty
              ? Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final item = _books[index];
                    final book = item['volumeInfo'];
                    final id = item['id'];
                    final title = book['title'] ?? 'No Title';
                    final authors = (book['authors'] ?? ['Unknown']).join(', ');
                    final thumbnail = book['imageLinks']?['thumbnail'];
                    final description = book['description'] ?? '';

                    final Map<String, String?> bookMap = {
                      'id': id.toString(),
                      'title': title,
                      'author': authors,
                      'thumbnail': thumbnail,
                      'description': description,
                    };

                    return FutureBuilder<bool>(
                      future: isFavorite(id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            leading: thumbnail != null
                                ? Image.network(thumbnail, width: 50, fit: BoxFit.cover)
                                : Icon(Icons.menu_book_outlined, size: 50),
                            title: Text(title),
                            subtitle: Text(authors),
                            trailing: CircularProgressIndicator(),
                          );
                        } else {
                          final isFavorite = snapshot.data ?? false;

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
                                      author: authors,
                                      description: description,
                                      imageUrl: thumbnail,
                                    ),
                                  ),
                                );
                              },
                            ),
                            subtitle: Text(authors),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.yellow : null,
                              ),
                              onPressed: () {
                                addFavoriteToFirestore(bookMap);
                              },
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}
