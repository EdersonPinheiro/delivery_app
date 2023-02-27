class User {
  String fullName;
  String email;
  String phone;

  User({
    required this.fullName,
    required this.email,
    required this.phone
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        fullName: json['fullname'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        );
  }
}