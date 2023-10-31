import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/auth.dart';

Future<List<fitness.Session>> fetchData(AutoRefreshingAuthClient client) async {
  try {
    var data = await fitness.FitnessApi(client).users.sessions.list(
      'me',
      activityType: [72], // 72 corresponds to sleep in Google Fit
    );
    return data.session ?? [];
  } catch (error) {
    print("Error fetching data: $error");
    return [];
  }
}