import 'package:bookapp/FavoritesPage.dart';
import 'package:bookapp/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'FavoritesProvider.dart';
import 'HomePage.dart';
import 'LoginPage.dart'; // <--- import AuthPage
import 'package:firebase_auth/firebase_auth.dart'; // <--- import FirebaseAuth

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: AIBookApp(),
    ),
  );
}

class AIBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Reading App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthWrapper(), // <--- Dynamic screen based on auth state

       // Define routes here
      routes: {
        '/login': (context) => AuthPage(), // Login Page
        '/home': (context) => HomePage(), // Home Page
        '/search': (context) => SearchPage(), // Search Page
        '/favorites': (context) => FavoritesPage(), // Favorites Page
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // watches login/logout
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return HomePage(); // user is logged in
        } else {
          return AuthPage(); // user is NOT logged in
        }
      },
    );
  }
}
