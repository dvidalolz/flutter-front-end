import 'package:circle_app/classes/surveydata.dart';
import 'package:circle_app/pages/homepage.dart';
import 'package:circle_app/pages/init_contactspage.dart';
import 'package:flutter/material.dart';
import '../classes/userdata.dart';
import '../components/button.dart';
import 'package:intl/intl.dart'; // Import the intl library
import 'dart:convert';
import 'package:http/http.dart' as http;

class InitSurveyPage extends StatefulWidget {
  final UserData userData;
  const InitSurveyPage({super.key, required this.userData});

  @override
  State<InitSurveyPage> createState() => _InitSurveyPageState();
}

class _InitSurveyPageState extends State<InitSurveyPage> {
  bool allValuesValid = true;
  //slidermaxdivisions
  final double MAX_AMOUNT = 5;
  final int MAX_DIVISIONS = 5;

  // slider values of all 20 questions
  List<double> currentSliderValues = List<double>.filled(18, 0);
  // strings for slider sliderLabels
  List<String> sliderLabels = [
    'Choose One',
    'Never',
    'Rarely',
    'Sometimes',
    'Often',
    'All the time'
  ];

  //calculation for parameter - average
  Map<String, dynamic> createMap() {
    // key value pairing
    Map<String, dynamic> map = {};

    List<String> keys = [
      'InterestDeviation',
      'Depression',
      'Sleep',
      'Social',
      'Focus',
      'Irritability',
      'ObsessionAddiction',
      'Suicidality',
      'Movement'
    ];

    List<List<int>> indexPairs = [
      [0, 10], // Interest deviation
      [1, 6], // Depression
      [2, 9], // Sleep
      [3, 7], // Social
      [4, 16], // Focus
      [5, 8], // Irritability
      [11, 12], // Obsession Addiction
      [13, 15], // Suicidallity
      [14, 17] // Movement
    ];

    // get the average of each pair of related questions
    for (int i = 0; i < indexPairs.length; i++) {
      int firstIndex = indexPairs[i][0];
      int secondIndex = indexPairs[i][1];
      double firstNumber = currentSliderValues[firstIndex];
      double secondNumber = currentSliderValues[secondIndex];
      double average = (firstNumber + secondNumber) / 2;
      map[keys[i]] = average;
    }

    return map;
  }

  //navigate to next page
  void _navigateToNext(BuildContext context, UserData userData) {
    userData.surveyData = SurveyData(
        createdAt: DateTime.now(),
        surveyMap: createMap(),
        userEmail: userData.email); // populate surveydata object with fields


    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InitContactsPage(userData: widget.userData)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Survey Page"),
          backgroundColor: Color(0x000e95).withOpacity(0.5),
        ),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "Please answer the following questions with how much they've applied to you within the last 4 week.",
                          style: TextStyle(
                            color: Color.fromARGB(255, 79, 77, 77),
                            fontSize: 16,
                          )),
                    ),
                    const SizedBox(height: 10),

                    // Question 1 (Interest Deviation)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have difficulty deriving pleasure or meaning from activities which you've historically considered pleasurable or productive.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[0],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[0].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[0] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 2 (Depression)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("You have been feeling depressed and hopeless.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[1],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[1].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[1] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 3 (Sleep)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("You have been unable to get quality sleep.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[2],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[2].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[2] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 4 (Social)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been isolated from your friends and family.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[3],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[3].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[3] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 5 (Focus)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been struggling with getting started on responsibilities and/or fail to complete them.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[4],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[4].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[4] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 6 (Irritability)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been short-tempered or quick to experience spite.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[5],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[5].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[5] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 7 (Depression)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been having trouble keeping up with self-hygiene.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[6],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[6].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[6] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 8 (Social)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You dissociated or felt disconnected from the world around you.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[7],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[7].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[7] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 9 (Irritability)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been easily irritated and/or have had sudden outbursts of negative emotions.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[8],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[8].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[8] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 10 (Sleep)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have had difficulty in getting enough sleep, or the reverse - sleeping too much.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[9],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[9].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[9] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 11 (Interest Deviation)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have felt unmotivated to move forward in life.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[10],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[10].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[10] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 12 (Obsessive)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been getting instrusive or obsessive thoughts that something will go wrong.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[11],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[11].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[11] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 13 (Addiction)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have been abusing drugs and/or alcohol to seek comfort or distraction.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[12],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[12].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[12] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 14 (Suicide)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have had thoughts that you or others would be better off if you were dead.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[13],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[13].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[13] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 15 (Movement)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You go for long stretches of time without moving.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[14],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[14].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[14] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 16 (Suicide)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("You have had thoughts of self harm.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[15],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[15].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[15] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 17 (Focus)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("You have had difficulty focusing on tasks.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[16],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[16].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[16] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),

                    // Question 18 (Movement)
                    Row(
                      children: const [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "You have experienced being fidgety or restless, or the opposite - slow and sluggish.",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Slider(
                      value: currentSliderValues[17],
                      max: MAX_AMOUNT,
                      divisions: MAX_DIVISIONS,
                      label: sliderLabels[currentSliderValues[17].toInt()],
                      inactiveColor: Colors.grey[200],
                      activeColor: Colors.blueGrey,
                      onChanged: (double value) {
                        setState(() {
                          currentSliderValues[17] = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.blueGrey,
                    ),
                    const SizedBox(height: 20),

                    // continue button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MyButton(
                          onTap: () {
                            for (int i = 0; i < 18; i++) {
                              if (currentSliderValues[i] <= 0) {
                                allValuesValid = false;
                                break;
                              } else {
                                allValuesValid = true;
                              }
                            }

                            if (allValuesValid) {
                              _navigateToNext(context, widget.userData);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('Please answer all the survey questions')),
                              );
                            }
                          },
                          message: "Continue Next"),
                    ),
                  ],
                ))));
  }
}
