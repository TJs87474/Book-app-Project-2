import 'package:bookapp/HomePage.dart';
import 'package:bookapp/Searchresultspage.dart';
import 'package:bookapp/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SearchPage()));
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<String> popular = ['Banned Book List', 'Springtime', 'BookTok'];
  final List<String> recent = [];
  final TextEditingController _controller = TextEditingController();

  void _handleSearch(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      recent.remove(query);
      recent.insert(0, query);
      if (recent.length > 3) recent.removeLast();
    });

    _controller.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchResultsPage(query: query)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
                MaterialPageRoute(builder: (context) => HomePage()),
      (route) => false, // This makes sure the HomePage is the only screen in the stack
            );
          },
        ),
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              onSubmitted: _handleSearch,
              decoration: InputDecoration(
                hintText: 'Keyword',
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  sectionTitle('Popular'),
                  ...popular.map((item) => searchItem(item)),
                  if (recent.isNotEmpty) sectionTitle('Recent'),
                  ...recent.map((item) => searchItem(item)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Divider(thickness: 1)),
        ],
      ),
    );
  }

  Widget searchItem(String title) {
    return ListTile(
      leading: Icon(Icons.menu_book_outlined),
      title: Text(title),
      onTap: () {
        _handleSearch(title);
      },
    );
  }
}
