class User {
  int? id;
  String username;
  String email;
  String password;
  String? fullName;
  String? dateOfBirth;
  String? gender;
  String? homeAddress;
  String? workAddress;
  String? nearestSafePlace;
  String? phoneNumber;
  String? emergencyContact;
  String? medicalConditions;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.homeAddress,
    this.workAddress,
    this.nearestSafePlace,
    this.phoneNumber,
    this.emergencyContact,
    this.medicalConditions,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };

    if (id != null) {
      map['id'] = id;
    }
    if (fullName != null) {
      map['fullName'] = fullName;
    }
    if (dateOfBirth != null) {
      map['dateOfBirth'] = dateOfBirth;
    }
    if (gender != null) {
      map['gender'] = gender;
    }
    if (homeAddress != null) {
      map['homeAddress'] = homeAddress;
    }
    if (workAddress != null) {
      map['workAddress'] = workAddress;
    }
    if (nearestSafePlace != null) {
      map['nearestSafePlace'] = nearestSafePlace;
    }
    if (phoneNumber != null) {
      map['phoneNumber'] = phoneNumber;
    }
    if (emergencyContact != null) {
      map['emergencyContact'] = emergencyContact;
    }
    if (medicalConditions != null) {
      map['medicalConditions'] = medicalConditions;
    }

    return map;
  }

  // Convert a Map object into a User object
  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        email = map['email'],
        password = map['password'],
        fullName = map['fullName'],
        dateOfBirth = map['dateOfBirth'],
        gender = map['gender'],
        homeAddress = map['homeAddress'],
        workAddress = map['workAddress'],
        nearestSafePlace = map['nearestSafePlace'],
        phoneNumber = map['phoneNumber'],
        emergencyContact = map['emergencyContact'],
        medicalConditions = map['medicalConditions'];
}
