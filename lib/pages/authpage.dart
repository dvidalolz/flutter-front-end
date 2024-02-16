import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'loginorregister.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? _email;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _email = user.email;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance
            .authStateChanges(), // authorized state changes
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return HomePage(userEmail: _email); // if cred correct, navigate to homepage
          }
          //user not logged in
          else {
            return const LoginOrRegisterPage(); // return login or register toggle pages
          }
        },
      ),
    );
  }
}
