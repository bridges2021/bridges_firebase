import 'package:bridges_firebase/Classes/AccessRight.dart';
import 'package:bridges_firebase/LocalSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../FirebaseSetting.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key? key, required this.app, required this.child}) : super(key: key);

  final FirebaseSetting app;
  final Widget child;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();

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
              'Create your account',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 30,
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            Container(
              height: 20,
            ),
            TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Email address')),
            Container(
              height: 20,
            ),
            TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Password')),
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
                child: _isLoading
                    ? CircularProgressIndicator.adaptive()
                    : Text(
                        'Create',
                        style: TextStyle(fontSize: 18),
                      ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await widget.app.createUserWithEmailAndPassword(
                      _nameController.text,
                      _emailController.text,
                      _passwordController.text);
                  final _localSettings = context.read<LocalSettings>();
                  _localSettings.userProfile.accessRight = AccessRight.init();
                  _localSettings.userProfile.locations = [];
                  _localSettings.userProfile.id = _emailController.text;
                  _localSettings.userProfile.email = _emailController.text;
                  _localSettings.userProfile.name = _nameController.text;
                  await widget.app.updateUserProfile(_localSettings.userProfile);
                  _localSettings.isUserSignedIn = true;
                  await _localSettings.set();
                  _localSettings.debug();
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
