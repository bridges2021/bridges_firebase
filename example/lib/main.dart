import 'package:bridges_firebase/LocalSettings.dart';
import 'package:bridges_firebase/bridges_firebase.dart';
import 'package:example/FirebaseSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeApps();
  } catch (e) {
    print(e);
  }
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => LocalSettings())],
    child: Phoenix(child: ExampleApp()),
  ));
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)))))),
      home: StartView(
        app: App.OpenProject.app,
        child: Scaffold(
          body: Center(
            child: ElevatedButton(
              child: Text('Sign out'),
              onPressed: () async {
                await App.OpenProject.app.auth.signOut();
                final _localSettings = context.read<LocalSettings>();
                _localSettings.isUserSignedIn = false;
                await _localSettings.set();
                Phoenix.rebirth(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
