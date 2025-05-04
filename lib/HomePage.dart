import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookapp/LoginPage.dart';
import 'package:bookapp/ChatRoomPage.dart'; 

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => AuthPage()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 100, color: Colors.black),
                const SizedBox(height: 16),
                const Text(
                  'Welcome User!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/favorites');
                  },
                  icon: const Icon(Icons.star),
                  label: const Text('My Favorites'),
                ),
                ElevatedButton.icon(
                icon: Icon(Icons.chat_bubble_outline),
                label: Text('Join Chatroom'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatRoomPage()),
                  );
                },
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
