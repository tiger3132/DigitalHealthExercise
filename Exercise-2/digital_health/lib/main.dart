import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:intl/intl.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Fit Step Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<fitness.DataPoint> stepCounts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Fit Step Count'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text("Fetch Google Fit Step Count"),
              onPressed: () async {
                List<fitness.DataPoint>? fetchedSessions = await authenticateAndFetchData();
                if (fetchedSessions != null) {
                  setState(() {
                    stepCounts = fetchedSessions.reversed.toList();
                  });
                }
              },
            ),
            SizedBox(height: 20),  // Provides some spacing
            Expanded(
              child: ListView.builder(
                itemCount: stepCounts.length,
                itemBuilder: (context, index) {
                  final session = stepCounts[index];

                  var val = session.value?.first.intVal;

                  var start = int.parse(session.startTimeNanos!) ~/ 1000;
                  var end = int.parse(session.endTimeNanos!) ~/ 1000;
                  final startDate = DateTime.fromMicrosecondsSinceEpoch(start);
                  final endDate = DateTime.fromMicrosecondsSinceEpoch(end);

                  final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
                  final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

                  return ListTile(
                    title: Text("Step count from $formattedStartDate to $formattedEndDate"),
                    subtitle: Text("Step Count: $val"),
                    // Modify as per your requirements
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}

