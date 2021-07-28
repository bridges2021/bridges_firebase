import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Classes/UserProfile.dart';

class FirebaseSetting {
  String name;
  String appId;
  String apiKey;
  String messagingSenderId;
  String projectId;

  FirebaseApp get app => Firebase.app(name);

  FirebaseAuth get auth => FirebaseAuth.instanceFor(app: app);

  FirebaseFirestore get store => FirebaseFirestore.instanceFor(app: app);

  FirebaseSetting(
      {required this.name,
      required this.appId,
      required this.apiKey,
      required this.messagingSenderId,
      required this.projectId});

  Future<FirebaseApp> initialize() async {
    print('App $name initializing...');
    try {
      final _firebaseApp = await Firebase.initializeApp(
          name: this.name,
          options: FirebaseOptions(
              apiKey: this.apiKey,
              appId: this.appId,
              messagingSenderId: this.messagingSenderId,
              projectId: this.projectId));
      print('App $name initialized!');
      return _firebaseApp;
    } catch (e) {
      throw 'App $name already created';
    }
  }

  Future<void> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    final _cred = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _cred.user!.updateDisplayName(name);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserProfile> getUserProfile() async {
    return UserProfile.fromMap(
        (await store.collection('Users').doc(auth.currentUser!.email).get())
                .data() ??
            {});
  }

  Future<void> updateUserProfile(UserProfile userProfile) async {
    await store
        .collection('Users')
        .doc(userProfile.id)
        .set(userProfile.toMap, SetOptions(merge: true));
  }
}
