import 'package:bridges_firebase/bridges_firebase.dart';

final List<FirebaseSetting> apps = [
  FirebaseSetting(
      name: 'yourName',
      appId: 'yourAppId',
      apiKey: 'yourApiKey',
      messagingSenderId:
          'yourMessagingSenderId',
      projectId: 'yourProjectId'),
  FirebaseSetting(
      name: 'yourName',
      appId: 'yourAppId',
      apiKey: 'yourApiKey',
      messagingSenderId:
      'yourMessagingSenderId',
      projectId: 'yourProjectId'),
];

enum App { Cardboard, Logistized }

extension Apps on App {
  FirebaseSetting get app {
    switch (this) {
      case App.Cardboard:
        return apps[0];
      case App.Logistized:
        return apps[1];

      default:
        return apps.first;
    }
  }
}

Future<void> appsInitialize() async {
  for (final app in apps) {
    try {
      await app.initialize();
    } catch (e) {
      print(e);
    }
  }
}
