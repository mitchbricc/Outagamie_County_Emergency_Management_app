class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String type;
  final String phone;
  final String salt;
  List<String> eventIds = [];

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.phone,
    required this.salt,
  });
}
