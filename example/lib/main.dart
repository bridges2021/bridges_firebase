import 'package:bridges_firebase/bridges_firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'FirebaseSettings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appsInitialize();
  runApp(MultiProvider(
    providers: [
      StreamProvider(
          create: (context) => App.Cardboard.app.streamUserChange(),
          initialData: null)
    ],
    child: ExampleApp(),
  ));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyView(),
    );
  }
}

class MyView extends StatefulWidget {
  const MyView({Key? key}) : super(key: key);

  @override
  _MyViewState createState() => _MyViewState();
}

class _MyViewState extends State<MyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase example'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () async {
                await App.Cardboard.app.signInWithGoogle();
                await App.Cardboard.app.createUserWithEmail(
                    'fanchungchit@icloud.com', 'fanchungchit@icloud.com');
                await App.Cardboard.app.updateProfileInfo(Info(name: 'Tony'));
              },
              child: Text('Create a new user first')),
          ElevatedButton(
              onPressed: () async {
                await App.Cardboard.app.auth.signOut();
              },
              child: Text('Sign out current user')),
          ElevatedButton(
              onPressed: () async {
                await App.Logistized.app.createUserWithEmail(
                    'fanchungchit@icloud.com', 'fanchungchit@icloud.com');
                await syncProfileInfo([App.Cardboard.app], App.Logistized.app);
              },
              child: Text('Create user with same email on second app')),
          ElevatedButton(
              onPressed: () async {
                final _profile = await App.Logistized.app.getProfile();
                print(_profile.toMap);
              },
              child: Text(
                  'Check info of second user, info should be same as first'))
        ],
      ),
    );
  }
}
