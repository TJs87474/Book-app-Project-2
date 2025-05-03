import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BookDetailsPage.dart'; // Make sure to create this file

class SearchResultsPage extends StatefulWidget {
  final String query;

  SearchResultsPage({required this.query});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<dynamic> _books = [];
  bool _isLoading = true;
  Set<String> _favorites = Set();

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

  void _toggleFavorite(String bookId) {
    setState(() {
      if (_favorites.contains(bookId)) {
        _favorites.remove(bookId);
      } else {
        _favorites.add(bookId);
      }
    });
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
                    final book = _books[index]['volumeInfo'];
                    final id = _books[index]['id'];
                    final title = book['title'] ?? 'No Title';
                    final authors = (book['authors'] ?? ['Unknown']).join(', ');
                    final thumbnail = book['imageLinks'] != null ? book['imageLinks']['thumbnail'] : null;
                    final description = book['description'] ?? '';

                    final isFavorite = _favorites.contains(id);

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
                        onPressed: () => _toggleFavorite(id),
                      ),
                    );
                  },
                ),
    );
  }
}
