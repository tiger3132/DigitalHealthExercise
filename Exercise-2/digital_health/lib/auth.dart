import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;


final _scopes = [
  'https://www.googleapis.com/auth/fitness.activity.read',
  'https://www.googleapis.com/auth/fitness.sleep.read'
];

Future<List<fitness.Session>?> authenticateAndFetchData() async {
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

Future<List<fitness.Session>> fetchData(http.Client client) async {
  var data = await fitness.FitnessApi(client).users.sessions.list(
    'me',
    activityType: [72], // 72 corresponds to sleep in Google Fit
  );
  return data.session ?? [];
}
