import 'bridges_firebase.dart';

Future<void> syncProfileInfo(List<FirebaseSetting> firebaseSettings, FirebaseSetting currentFirebaseSetting) async {
  print('Syncing user ${currentFirebaseSetting.email}');
  if (currentFirebaseSetting.email != null) {
    for (final firebaseSetting in firebaseSettings) {
      final _existProfile = await firebaseSetting.getProfileByEmail(currentFirebaseSetting.email!);
      if (_existProfile.info != null) {
        currentFirebaseSetting.updateProfileInfo(_existProfile.info!);
      }
    }
  }
}
