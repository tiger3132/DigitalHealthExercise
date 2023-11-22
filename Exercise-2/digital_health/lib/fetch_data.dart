import 'package:googleapis/fitness/v1.dart' as fitness;
import 'package:googleapis_auth/auth.dart';

Future<List<fitness.DataPoint>> fetchData(AutoRefreshingAuthClient client) async {
  try {
    var data = await fitness.FitnessApi(client).users.sessions.list(
      'me',
      activityType: [7], // 72 corresponds to sleep in Google Fit
    );
    final DateTime endTime = DateTime.now();
    final DateTime startTime = endTime.subtract(Duration(days: 7));
    final fitness.Dataset dataset = await fitness.FitnessApi(client).users.dataSources.datasets.get(
      'me',
      'derived:com.google.step_count.delta:com.google.android.gms:estimated_steps',
      // '${1668715722000 * 1000000}-${1700251722000 * 1000000}',
      '${startTime.millisecondsSinceEpoch * 1000000}-${endTime.millisecondsSinceEpoch * 1000000}'
    );
    return dataset.point ?? [];
  } catch (error) {
    print("Error fetching data: $error");
    return [];
  }
}
