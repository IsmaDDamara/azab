import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String jarak = "0";
  List<DataPoint> dataPoints = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child('azab/jarak').onValue.listen((event) {
      var data = event.snapshot.value;
      var timestamp = DateTime.now().millisecondsSinceEpoch.toDouble();

      setState(() {
        dataPoints.add(DataPoint(timestamp, double.parse(data.toString())));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LineChartData createLineChartData() {
      return LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: dataPoints.map((dataPoint) {
              return FlSpot(dataPoint.x, dataPoint.y);
            }).toList(),
          ),
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          height: 300,
          child: LineChart(createLineChartData()),
        ),
      ),
    );
  }
}
