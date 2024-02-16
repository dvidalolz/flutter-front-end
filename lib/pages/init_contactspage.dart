import 'package:flutter/material.dart';
import '../classes/contact.dart';
import '../classes/userdata.dart';
import '../components/button.dart';
import '../components/textformfield.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class InitContactsPage extends StatefulWidget {
  final UserData userData;
  const InitContactsPage({super.key, required this.userData});

  @override
  State<InitContactsPage> createState() => _InitContactsPageState();
}

class _InitContactsPageState extends State<InitContactsPage> {
  //formkey for input validation
  final _formkey = GlobalKey<FormState>();

  List<Contact> contacts =
  List.empty(growable: true); // list to stored created contacts

  // controllers for textfields
  final nameController = TextEditingController();
  final numberController = TextEditingController();

  int selectedIndex = -1;

  // regular expression for phone number input validation
  final RegExp phoneRegex = RegExp(r'^\d{10}$');

  // navigate to next
  _navigateToNext(context, UserData userData) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage(userEmail: widget.userData.email)),
          (route) => false,
    );
  }

  // phone number input validation function
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number in example format';
    }
    return null;
  }

  Widget getRow(index) {
    // function to create and manage contact list tile
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Card(
        child: ListTile(
            leading: CircleAvatar(
              // circular avatar for created contacts
              backgroundColor: index % 2 == 0 ? Colors.blueGrey : Colors.amber,
              foregroundColor: Colors.white,
              child: Text(
                contacts[index].name[0],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // contact name and number representation in created list tile
                Text(contacts[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight
                            .bold)), // !! must insert information from json here !!
                Text(contacts[index].number),
              ],
            ),
            trailing: SizedBox(
              // edit and delete buttons in created list tiles
              width: 70,
              child: Row(
                children: [
                  InkWell(
                      onTap: (() {
                        nameController.text = contacts[index].name.trim();
                        numberController.text = contacts[index].number.trim();
                        setState(
                              () {
                            selectedIndex = index;
                          },
                        );
                      }),
                      child: const Icon(Icons.edit)),
                  InkWell(
                      onTap: (() {
                        setState(() {
                          contacts.removeAt(index);
                        });
                      }),
                      child: const Icon(Icons.delete)),
                ],
              ),
            )),
      ),
    );
  }

  void sendUserData(UserData userData) async {
    String apiUrl = 'https://signupflow.azurewebsites.net/api/personalinfo';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Request-Type': 'Add'
    };
    String body = json.encode(userData.toJson());
    debugPrint("body of frontend payload request: $body");

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Sucess!');
      } else {
        print('Failure');
        // Handle error response
      }
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: AppBar(
          // appbar
          title: const Text("Trusted Contacts"),
          backgroundColor: Color(0x000e95).withOpacity(0.5),
        ),
        backgroundColor: Colors.grey[300],
        body: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Enter the names and numbers of at least 2 trusted friends/family!'),
            const SizedBox(height: 20),
            MyTextFormField(
              // name textfield
                controller: nameController,
                hintText: 'Contact Name',
                inputError: 'Please include name',
                obscureText: false),
            const SizedBox(height: 20),
            Padding(
              // number textfield
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextFormField(
                controller: numberController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color.fromARGB(255, 56, 52, 52)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Ex: 2133449081",
                  hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                ),
                keyboardType: TextInputType.phone,
                validator: validatePhoneNumber,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  // add button
                  onPressed: () {
                    String name = nameController.text.trim();
                    String number = numberController.text.trim();
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        nameController.text = '';
                        numberController.text = '';
                        contacts.add(Contact(name: name, number: number));            // contact added here
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  // update button
                    onPressed: () {
                      String name = nameController.text.trim();
                      String number = numberController.text.trim();
                      if (_formkey.currentState!.validate()) {
                        setState(() {
                          nameController.text = '';
                          numberController.text = '';
                          contacts[selectedIndex].name = name;
                          contacts[selectedIndex].number = number;
                          selectedIndex = -1;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16), // Button padding
                    ),
                    child: const Text('Update')), // Button text
              ],
            ),
            const SizedBox(height: 20),
            contacts.isEmpty // if contacts list is empty, print empty statement
                ? const Text('No Contacts yet...',
                style: TextStyle(fontSize: 22))
                : Expanded(
              // if not empty, build list with contents
              child: ListView.builder(
                  itemCount: contacts.length, // item count
                  itemBuilder: (context, index) => getRow(
                      index)), // for each item, builds with context and takes in the index
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyButton(
                  onTap: () {
                    if (contacts.length >= 2) {
                      widget.userData.trustedContacts = contacts;                                   // assign newly added contacts to userData object's contact list
                      sendUserData(widget.userData);                                                // send to backend
                      _navigateToNext(context, widget.userData);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                            Text('Please add at least 2 contacts.')),
                      );
                    }
                  },
                  message: "Continue Next"),
            ),
          ],
        ),
      ),
    );
  }
}