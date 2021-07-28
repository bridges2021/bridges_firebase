import 'dart:convert';

import 'package:bridges_firebase/Classes/Location.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Classes/UserProfile.dart';

class LocalSettings with ChangeNotifier {
  late SharedPreferences prefs;

  bool isLocalDevice = false;
  bool isUserSignedIn = false;
  late Location currentLocation;
  late UserProfile userProfile;

  Future<void> get() async {
    prefs = await SharedPreferences.getInstance();
    isLocalDevice = prefs.getBool('isLocalDevice') ?? false;
    isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;
    currentLocation =
        Location.fromMap(json.decode(prefs.getString('currentLocation') ?? '{}'));
    userProfile =
        UserProfile.fromMap(json.decode(prefs.getString('userProfile') ?? '{}'));
  }

  Future<void> set() async {
    await prefs.setBool('isLocalDevice', isLocalDevice);
    await prefs.setBool('isUserSignedIn', isUserSignedIn);
    await prefs.setString('currentLocation', json.encode(currentLocation.toMap));
    await prefs.setString('userProfile', json.encode(userProfile.toMap));
  }

  void debug() async {
    print('Local settings: isLocalDevice: $isLocalDevice, isUserSignedIn: $isUserSignedIn, currentLocation: ${json.encode(currentLocation.toMap)}, userProfile: ${json.encode(userProfile.toMap)}');
  }
}
