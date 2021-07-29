import 'package:bridges_firebase/bridges_firebase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../LocalSettings.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key, required this.app, required this.child})
      : super(key: key);

  final FirebaseSetting app;
  final Widget child;

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ELLIE'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 70),
        child: ListView(
          children: [
            Text(
              'Sign in your account',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 30,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email address',
              ),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                child: _isLoading? CircularProgressIndicator.adaptive(): Text('Sign in'),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await widget.app.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                  final _userProfile = await widget.app.getUserProfile();
                  final _localSettings = context.read<LocalSettings>();
                  _localSettings.isUserSignedIn = true;
                  _localSettings.userProfile = _userProfile;
                  await _localSettings.set();
                  setState(() {
                    _isLoading = false;
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.child));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
