import 'package:flutter/material.dart';

void main() {
  runApp(AIBookApp());
}

class AIBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Reading App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Customize your theme here if needed.
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace 'assets/logo.png' with your actual logo asset path.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                Image.file(
                  image/ui_design/home_page.png,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                */
                // Logo Section
                Icon(
                  Icons.menu_book,
                  size: 100,
                  color: Colors.blue, // color of icon
                ),
                const SizedBox(height: 16),
                // Greeting Text
                const Text(
                  'Welcome User!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // "My Reading Lists" Button
                ElevatedButton.icon(
                  onPressed: () {
                    // No functionality added per config
                  },
                  icon: const Icon(Icons.menu_book),
                  label: const Text('My Reading Lists'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // "Search" Button
                ElevatedButton.icon(
                  onPressed: () {
                    // No functionality added per config
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // "Message Boards" Button
                ElevatedButton.icon(
                  onPressed: () {
                    // No functionality added per config
                  },
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Message Boards'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}