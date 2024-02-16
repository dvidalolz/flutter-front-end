import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';


class SurveyChart extends StatefulWidget {
  final String userEmail;

  const SurveyChart({required this.userEmail});

  @override
  _SurveyChartState createState() => _SurveyChartState();
}

class _SurveyChartState extends State<SurveyChart> {
  List<DateTime> createdAtDates = [];
  List<double> averages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Generate 10 random sentiment scores between 0 and 5, sorted in ascending order
    List<double> scores = List.generate(10, (index) => ( (Random().nextInt(5))+1) * 0.5);

    // Generate corresponding dates in ascending order
    List<DateTime> dates = List.generate(10, (index) {
      // Create a date between May 1, 2023 and May 10, 2023, sorted in ascending order
      return DateTime(2023, 5, index + 1);
    });

    // Set the state with the generated data
    averages = scores;
    createdAtDates = dates;
    setState(() {});
  }


  void processChartData(List<dynamic> data) {
    data.forEach((survey) {
      Map<String, dynamic> surveyMap = survey['surveyMap'];
      double sum = 0;
      int count = 0;

      surveyMap.forEach((key, value) {
        sum += value;
        count++;
      });

      double average = sum / count;
      averages.add(average); //this would contain the sentiment scores from the backend
      createdAtDates.add(DateTime.parse(survey['createdAt'])); //this will contain the dates for each sentiment score
    });

    // Filter out dates that are before today's date
    final today = DateTime.now();
    createdAtDates = createdAtDates.where((date) => date.isAfter(today)).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(dateFormat: DateFormat('MM/dd/yyyy')),
      primaryYAxis: NumericAxis(minimum: 0, maximum: 5), // Change the range based on your data values
      series: <ChartSeries>[
        LineSeries<Tuple2<DateTime, double>, DateTime>(
          dataSource: List.generate(
            createdAtDates.length,
                (index) => Tuple2(createdAtDates[index], averages[index]), //createdAtDates and averages would be the data returned from the backend
          ),
          xValueMapper: (Tuple2<DateTime, double> data, _) => data.item1,
          yValueMapper: (Tuple2<DateTime, double> data, _) => data.item2,
        ),
      ],
    );
  }


}

class Tuple<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple(this.item1, this.item2);
}