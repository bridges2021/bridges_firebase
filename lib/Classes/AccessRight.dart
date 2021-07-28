class AccessRight {
  ItemAccess itemAccess;

  AccessRight({required this.itemAccess});

  factory AccessRight.fromMap(Map<String, dynamic> map) {
    return AccessRight(
        itemAccess: ItemAccess.fromMap(map['itemAccess'] ?? {}));
  }

  factory AccessRight.init() {
    return AccessRight( itemAccess: ItemAccess());
  }

  Map<String, dynamic> get toMap => {
    'itemAccess': itemAccess.toMap
  };
}

class ItemAccess {
  bool read;
  bool write;

  ItemAccess({this.read = false, this.write = false});

  factory ItemAccess.init() {
    return ItemAccess();
  }

  factory ItemAccess.fromMap(Map<String, dynamic> map) {
    return ItemAccess(
      read: map['read'] ?? false,
      write: map['write'] ?? false,
    );
  }

  Map<String, dynamic> get toMap => {
    'read': read,
    'write': write,
  };
}
