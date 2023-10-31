import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:intl/intl.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Fit Sleep Data',
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
  List<fitness.Session> sleepSessions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Fit Sleep Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: Text("Fetch Google Fit Sleep Data"),
              onPressed: () async {
                List<fitness.Session>? fetchedSessions = await authenticateAndFetchData();
                if (fetchedSessions != null) {
                  setState(() {
                    sleepSessions = fetchedSessions;
                  });
                }
              },
            ),
            SizedBox(height: 20),  // Provides some spacing
            Expanded(
              child: ListView.builder(
                itemCount: sleepSessions.length,
                itemBuilder: (context, index) {
                  final session = sleepSessions[index];
                  final startDate = DateTime.fromMillisecondsSinceEpoch(int.parse(session.startTimeMillis!));
                  final endDate = DateTime.fromMillisecondsSinceEpoch(int.parse(session.endTimeMillis!));

                  final formattedStartDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
                  final formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

                  return ListTile(
                    title: Text("Sleep Session"),
                    subtitle: Text("Sleep Time: $formattedStartDate\nWake-up Time: $formattedEndDate"),
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

