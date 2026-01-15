class AdminModel {
  final String name;

  final String surname;
  final String passcode;
  final String uniqueId;
  final bool isBanned;
  final Object allAccesses;



  AdminModel({
    required this.name,
    required this.passcode,
     required this.surname,
    required this.uniqueId,
    required this.isBanned,
    required this.allAccesses,

  });

// Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'allAccesses': allAccesses,

      'surname': surname,
      'passcode': passcode,
      'uniqueId': uniqueId,
      'isBanned': isBanned,

    };
  }
}
