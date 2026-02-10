class User {
  final String? id;
  final String fullName;
  final String email;
  final String? mobile;
  final String? language;
  final String? literacyLevel;
  final String? token; // For login response

  User({
    this.id,
    required this.fullName,
    required this.email,
    this.mobile,
    this.language,
    this.literacyLevel,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'],
      language: json['language'],
      literacyLevel: json['literacyLevel'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'mobile': mobile,
      'language': language,
      'literacyLevel': literacyLevel,
    };
  }
}
