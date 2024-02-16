import 'package:circle_app/pages/personalinfopage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../classes/userdata.dart';
import '../components/button.dart';
import '../components/textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // user input error function
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

  // user sign up function
  void signUserUp(BuildContext context, UserData userData) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try creating user
    try {
      // check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        if (passwordController.text.length >= 6) {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          userData.email = emailController.text;
          userData.password = passwordController.text;
        } else {
          Navigator.pop(context);
          showErrorMessage('Password must be at least 6 characters');
        }
      } else {
        Navigator.pop(context);
        //show error message: passwords don't match
        showErrorMessage("Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // show error message
      showErrorMessage(e.code);
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User has been created, log data and continue to next page

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PersonalInfoPage(userData: userData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    UserData userData = UserData();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registration Page"),
          backgroundColor: Color(0x000e95).withOpacity(0.5),
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.radio_button_unchecked,
                        size: 75,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // create account text
                  const Text("Let's create an account for you!",
                      style: TextStyle(
                        color: Color.fromARGB(255, 79, 77, 77),
                        fontSize: 16,
                      )),
                  const SizedBox(height: 20),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // sign in button
                  MyButton(
                    onTap: () {
                      signUserUp(context, userData);
                    },
                    message: "Register",
                  ),
                  const SizedBox(height: 50),

                  // New user? Register link text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login now",
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
