import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;


final _scopes = [
  'https://www.googleapis.com/auth/fitness.activity.read',
  'https://www.googleapis.com/auth/fitness.sleep.read'
];

Future<List<fitness.DataPoint>?> authenticateAndFetchData() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  try {
    GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      GoogleSignInAuthentication auth = await account.authentication;

      final expiryDate = DateTime.now().add(
        Duration(seconds: 3600),  // Assuming a default of 1 hour
      ).toUtc();

      final credentials = AccessCredentials(
        AccessToken(
          'Bearer',  // Hard-coded token type
          auth.accessToken!,
          expiryDate,
        ),
        null,
        _scopes,
      );

      final client = authenticatedClient(http.Client(), credentials);
      return fetchData(client);
    }
  } catch (error) {
    print(error);
  }
  return null;
}

Future<List<fitness.DataPoint>> fetchData(http.Client client) async {
  var data = await fitness.FitnessApi(client).users.sessions.list(
    'me',
    activityType: [7], // 72 corresponds to sleep in Google Fit
  );
  final DateTime endTime = DateTime.now();
  final DateTime startTime = endTime.subtract(Duration(days: 7));
  final fitness.Dataset dataset = await fitness.FitnessApi(client).users.dataSources.datasets.get(
    'me',
    'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps',
      '${startTime.millisecondsSinceEpoch * 1000000}-${endTime.millisecondsSinceEpoch * 1000000}',
  );
  return dataset.point ?? [];
}
