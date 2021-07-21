# bridges_firebase
 Control multiple firebase
## Installation
```yaml
bridges_firebase:
  git:
    url: https://github.com/bridges2021/bridges_firebase.git
    ref: main
```
## How to use
### Basic
1. Set keys
```dart
final List<FirebaseSetting> apps = [
  FirebaseSetting(
      name: 'yourName',
      appId: 'yourAppId',
      apiKey: 'yourApiKey',
      messagingSenderId:
          'yourMessagingSenderId',
      projectId: 'yourProjectId'),
];
```
2. Set up for easy call
```dart
enum App { Your, App }

extension Apps on App {
  FirebaseSetting get app {
    switch (this) {
      case App.Your:
        return apps[0];
      case App.App:
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
```
3. Call Firebase initialize in main
```dart
await appsInitialize();
```
4. Use built functions
```dart
await App.Your.app.createUserWithEmail('email', 'password');
await App.App.app.signInWithGoogle();
```
5. Finish
### Firebase Authenication synchronize
1. Just put syncProfileInfo() after creating a user
```dart
await App.Logistized.app.createUserWithEmail('fanchungchit@icloud.com', 'fanchungchit@icloud.com');
await syncProfileInfo([App.TheOtherApps.app], App.TheAppYouAreSigningIn.app);
```
2. Finish
