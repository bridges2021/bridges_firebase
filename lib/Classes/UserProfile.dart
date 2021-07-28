import 'package:bridges_firebase/Classes/Location.dart';
import 'AccessRight.dart';

class UserProfile {
  String id;
  String name;
  String email;
  AccessRight accessRight;
  List<Location> locations;

  UserProfile(
      {required this.id,
      required this.name,
      required this.email,
      required this.accessRight,
      required this.locations});

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        accessRight: AccessRight.fromMap(map['accessRight'] ?? {}),
        locations: List<Location>.from((map['locations'] ?? [])
            .map((location) => Location.fromMap(location))
            .toList()));
  }

  Map<String, dynamic> get toMap => {
        'id': id,
        'name': name,
        'email': email,
        'accessRight': accessRight.toMap,
        'locations': locations.map((location) => location.toMap).toList(),
      };

  void debug() {
    print(
        'id: $id, name: $name, email: $email, AccessRight: ${accessRight.toMap}, locations: ${locations.map((location) => location.toMap).toList()}');
  }
}
