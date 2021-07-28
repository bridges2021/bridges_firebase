class Location {
  String id;
  String name;

  Location({required this.id, required this.name});

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(id: map['id'] ?? '', name: map['name'] ?? '');
  }

  Map<String, dynamic> get toMap => {
    'id': this.id,
    'name': this.name
  };
}