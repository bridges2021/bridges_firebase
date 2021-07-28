import 'package:bridges_firebase/Classes/UserProfile.dart';
import 'package:bridges_firebase/Views/SignInView.dart';
import 'package:bridges_firebase/Views/SignUpView.dart';
import 'package:flutter/material.dart';

import '../FirebaseSetting.dart';
import 'package:provider/provider.dart';

import '../LocalSettings.dart';

class StartView extends StatelessWidget {
  const StartView({Key? key, required this.app, required this.child})
      : super(key: key);

  final FirebaseSetting app;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _localSettings = context.read<LocalSettings>();
    return FutureBuilder(
      future: _localSettings.get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
        }

        if (snapshot.connectionState == ConnectionState.done) {
          _localSettings.debug();
          if (_localSettings.isUserSignedIn) {
            return FutureBuilder(
              future: app.getUserProfile(),
              builder: (context, AsyncSnapshot<UserProfile> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  _localSettings.userProfile = snapshot.data!;
                  return child;
                }

                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              },
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('ELLIE'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          'Everything you need is here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 60,
                                child: ElevatedButton(
                                  child: Text(
                                    'Create account',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => SignUpView(
                                                  app: app,
                                                  child: child,
                                                )));
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: TextButton(
                          child: Text(
                            'Sign in',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        SignInView(app: app, child: child)));
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}
