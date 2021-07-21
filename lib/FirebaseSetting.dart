import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';


enum Role {
  PENDING,
  ACTIVE,
  INACTIVE,
  ERROR,
}

class Info {
  String name;

  Info({required this.name});

  factory Info.fromMap(Map<String, dynamic> map) {
    return Info(name: map['name'] ?? 'name error');
  }

  Map<String, dynamic> get toMap => {'name': name};
}

class Profile {
  DocumentReference? ref;
  String? get id => ref?.id;
  Role role;
  Info? info;

  Profile({required this.role, this.ref, this.info});

  factory Profile.initialize() {
    return Profile(role: Role.PENDING);
  }

  factory Profile.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final _data = documentSnapshot.data() ?? {};
    return Profile(
        ref: documentSnapshot.reference,
        role: Role.values.elementAt(_data['role'] ?? 0),
        info: _data['info'] != null
            ? Info.fromMap(Map<String, dynamic>.from(_data['info']))
            : null);
  }

  Map<String, dynamic> get toMap =>
      {'role': Role.values.indexOf(this.role), 'info': this.info?.toMap};
}

class FirebaseSetting {
  String name;
  String appId;
  String apiKey;
  String messagingSenderId;
  String projectId;

  FirebaseSetting(
      {required this.name,
        required this.appId,
        required this.apiKey,
        required this.messagingSenderId,
        required this.projectId});

  FirebaseApp get app => Firebase.app(this.name);

  FirebaseAuth get auth => FirebaseAuth.instanceFor(app: this.app);

  User? get user => this.auth.currentUser;

  String? get email => this.user?.email;

  FirebaseFirestore get store => FirebaseFirestore.instanceFor(app: this.app);

  CollectionReference<Map<String, dynamic>> get userCollection => this.store.collection('Users');

  Future<void> createProfile() async {
    print('Creating profile on $name...');
    try {
      if (this.user == null) {
        throw 'No user found';
      } else if (this.user!.email == null) {
        throw 'Email is empty';
      } else {
        this
            .store
            .collection('Users')
            .doc(this.user!.email)
            .set(Profile.initialize().toMap);
        print(
            'Profile created on $name! ID: ${this.user!.email}, data: ${Profile.initialize().toMap}');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Profile> getProfile() async {
    if (this.email != null) {
      print('Getting profile of $email on $name');
      final _profile = Profile.fromDocument(
          (await this.store.collection('Users').doc(email).get()));
      print('Got profile of $email on $name');
      return _profile;
    } else {
      throw 'Email is empty';
    }
  }

  Future<Profile> getProfileByEmail(String email) async {
    final _doc = await this.userCollection.doc(email).get();
    if (_doc.exists) {
      return Profile.fromDocument(_doc);
    } else {
      throw 'User email $email not exists';
    }
  }

  Future<void> updateProfileInfo(Info info) async {
    print('Updating $email ${info.toMap}');
    if (this.email != null) {
      await this
          .store
          .collection('Users')
          .doc(email)
          .update({'info': info.toMap});
    } else {
      throw 'User email not found';
    }
    print('Updated $email ${info.toMap}');
  }

  ///Abandon as uid can not be used to check on other Firebase
  // Future<void> linkUserId(String uid) async {
  //   print('Linking user ID $uid to ${this.name}...');
  //   try {
  //     if (this.auth.currentUser != null &&
  //         !this.auth.currentUser!.isAnonymous) {
  //       await this
  //           .store
  //           .collection('Users')
  //           .doc(this.auth.currentUser!.uid)
  //           .update({
  //         'link': FieldValue.arrayUnion([uid])
  //       });
  //       print('Linked user ID $uid to ${this.auth.currentUser!.uid}!');
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Stream<User?> streamUserChange() {
    return this.auth.userChanges();
  }

  Future<UserCredential> createUserWithEmail(
      String email, String password) async {
    print('Creating user with email $email on $name...');
    try {
      final _userCredential = await this
          .auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print('Created user with email $email on $name!');
      if (_userCredential.additionalUserInfo!.isNewUser) {
        await createProfile();
      }
      return _userCredential;
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    print('Signing in with email $email on $name...');
    try {
      final _userCredential = await this
          .auth
          .signInWithEmailAndPassword(email: email, password: password);
      print('Signed in with email $email on $name!');
      return _userCredential;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> emailVerify() async {
    print('Verifying ${this.user?.uid} email on $name...');
    try {
      if (this.user == null) {
        throw 'No user found';
      } else {
        if (this.user!.emailVerified) {
          print('Verified ${this.user?.uid} email on $name? true');
          return true;
        } else {
          await this.user!.sendEmailVerification();
          print(
              'Verified ${this.user?.uid} email on $name? false\nSent email verification to ${this.user!.uid} on $name');
          return false;
        }
      }
    } catch (e) {
      throw e;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    print('Signing in with google on $name...');
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final _userCredential = await this.auth.signInWithCredential(credential);
      if (_userCredential.additionalUserInfo!.isNewUser) {
        await createProfile();
      }
      print('Signed in with google on $name as ${_userCredential.user!.uid}');
      return _userCredential;
    } catch (e) {
      throw 'Sign in with google error: $e';
    }
  }

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
      print('App $name already created');
      throw e;
    }
  }
}
