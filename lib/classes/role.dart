class Role {
  String role;
  String firstName;
  String lastName;

  Role({
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory Role.fromMap(Map<String, dynamic> map) {
    return Role(
      role: map['role'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
