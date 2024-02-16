import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/button.dart';
import '../components/textfield.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _forgotEmailController = TextEditingController();

  // user sign in function
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // user sign in error function
    void showErrorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.deepOrange,
            title: Center(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          );
        },
      );
    }

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // show error message (wrong email/pass)
      showErrorMessage(e.code);

    }
  }
  void _sendResetPasswordEmail() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _forgotEmailController.text);
      // pop loading circle and show success message
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Password Reset Email Sent'),
            content: const Text('Please check your email to reset your password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // pop loading circle and show error message
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error Sending Reset Email'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
          backgroundColor: Color(0x000e95).withOpacity(0.5),
        ),
        backgroundColor: Color.fromRGBO(224, 224, 224, 1),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Container(
                        width: 100,
                        height: 100,
                        child: Image(
                          image: AssetImage('lib/assets/logo.png'),

                        ),
                      ),
                      SizedBox(width: 12),

                      Text("MyCircle",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 60, color: Colors.black,)),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // welcome back text
                  const Text("Welcome!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 77, 77),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      )),
                  const SizedBox(height: 30),

                  // username textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Username",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                    message: "Sign In",
                  ),
                  const SizedBox(height: 20),
// forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
// forgot username/password button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0x000e95).withOpacity(0.5),

                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          onPressed: () {
                            // show forgot username/password dialog box
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Forgot Username/Password'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MyTextField(
                                        controller: _forgotEmailController,
                                        hintText: 'Enter Email Address',
                                        obscureText: false,
                                      ),
                                      const SizedBox(height: 20),
                                      MyButton(
                                        onTap: _sendResetPasswordEmail,
                                        message: 'Send Reset Email',
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            'Forgot Username/Password?',

                            style: TextStyle(color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                      ],
                    ),
                  ),
                  // New user? Register link text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a member?",
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}