import 'package:flutter/material.dart';
import '../classes/contact.dart';
import '../components/textformfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactsPage extends StatefulWidget {
  final String? userEmail;
  const ContactsPage({super.key, required this.userEmail});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
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

  //Future<List<Contact>> fetchContacts(String? username) async {
  Future<dynamic> fetchContacts(String? username) async {
    // Replace the URL with your API endpoint
    // final response = await http.get(Uri.parse('https://signupflow.azurewebsites.net/api/contacts'));
    debugPrint('fetchContacts() username: $username');
    String apiUrl = 'https://signupflow.azurewebsites.net/api/contacts';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Request-Type': 'Get',
    };

    var email = widget.userEmail ?? '';

    Map<String, String> queryParams = {
      'email': email,
      'Request-Type': 'Get',
    };

    Uri apiUrlWithParams =
    Uri.parse(apiUrl).replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        //Uri.parse(apiUrl),
        apiUrlWithParams,
        headers: headers,
        // body: body,
      );

      /*
        parse the response and store as contact objs
       {"{\"name\":\"bro\",\"number\":\"1234567890\"}",
       "{\"name\":\"jees\",\"number\":\"1234567890\"}"}
      */
      //Map<String, dynamic> jsonResponse = response.body;

      // List<Map<String, dynamic>> parsedJson = jsonDecode(response.body);

      // Parse the JSON response string to a List of strings
      List<dynamic> parsedJson = jsonDecode(response.body);
      debugPrint("parsedJson: $parsedJson");
      // Iterate through the list, parse the nested JSON strings, and print the name and number fields

      //setting state to update contacts list after retrieving from api call/
      setState(
            () {
          for (dynamic contactObj in parsedJson) {
            //Map<dynamic, dynamic> contact = jsonDecode(contactObj);
            contacts.add(Contact(
                name: contactObj["name"], number: contactObj["number"]));
            debugPrint('contact: $contactObj');
            debugPrint('contacts List: $contacts');
          }
        },
      );

      debugPrint("response from get contacts call: ${response.body}");
      if (response.statusCode == 200) {
        print('Sucess!');
        return response.body;
      } else {
        print('Failure');
        // Handle error response
      }
    } catch (e) {
      // Handle exceptions
      print(e);
    }

    //return response.body;

    //return "contacts loaded";
    //return Contact(name: "hello", number: number)
  }

  //function call to access the api and store the contact details
  void saveContactChanges() async {
    var contact = contacts[0].toJson();
    //create an array to store the json objects
    var contactList = [];
    //loop through the contacts list and store the json objects in an array to be sent as the payload
    for (var i = 0; i < contacts.length; i++) {
      contact = contacts[i].toJson();
      //store it in an array
      contactList.add(contact);
    }

    debugPrint("addContact called $contactList");

    String apiUrl = 'https://signupflow.azurewebsites.net/api/contacts';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    String body = json.encode({
      'email': widget.userEmail,
      'contacts': contactList,
      'Request-Type': 'Add',
    });

    debugPrint("request body: $body");

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
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      // Replace 'yourUsername' with the actual username
      // List<Contact> fetchedContacts = await fetchContacts(widget.userEmail);
      // setState(() {
      //   contacts = fetchedContacts;
      // });

      String response = await fetchContacts(widget.userEmail);
      //Future<dynamic> resBod = response.body;
      debugPrint("the response from fetching contacts: $response");
    } catch (e) {
      debugPrint('Error fetching contacts: $e');
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
            backgroundColor: Colors.black,
          ),
          backgroundColor: Colors.grey[300],
          body: Column(
            children: [
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
                    hintStyle:
                    TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
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
                          contacts.add(Contact(name: name, number: number));
                        });
                      }
                      //make the function call to access the api:
                      //saveContactChanges();
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
                        //String name = nameController.text.trim();
                        //String number = numberController.text.trim();
                        // if (_formkey.currentState!.validate()) {
                        //   setState(() {
                        //     nameController.text = '';
                        //     numberController.text = '';
                        //     contacts[selectedIndex].name = name;
                        //     contacts[selectedIndex].number = number;
                        //     selectedIndex = -1;
                        //   });
                        // }

                        //make the function call to access the api:
                        saveContactChanges();
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
                      child: const Text('Save Changes')),
                  // ElevatedButton(
                  //     // update button
                  //     onPressed: () {
                  //       String name = nameController.text.trim();
                  //       String number = numberController.text.trim();
                  //       if (_formkey.currentState!.validate()) {
                  //         setState(() {
                  //           nameController.text = '';
                  //           numberController.text = '';
                  //           contacts[selectedIndex].name = name;
                  //           contacts[selectedIndex].number = number;
                  //           selectedIndex = -1;
                  //         });
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.black, // Background color
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius:
                  //             BorderRadius.circular(16), // Rounded corners
                  //       ),
                  //       padding: const EdgeInsets.symmetric(
                  //           horizontal: 32, vertical: 16), // Button padding
                  //     ),
                  //     child: const Text('Save Changes')), // Button text
                ],
              ),
              const SizedBox(height: 20),
              contacts.isEmpty
                  ? const Text('No Contacts yet...',
                  style: TextStyle(fontSize: 22))
                  : Expanded(
                child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) => getRow(index)),
              )
            ],
          )),
    );
  }
}