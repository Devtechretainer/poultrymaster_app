/// Domain entity - User model
/// Pure business data model, no Flutter/API dependencies
class User {
  final String id;
  final String farmId; // Farm ID for API calls
  final String farmName;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? token;

  const User({
    required this.id,
    required this.farmId,
    required this.farmName,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.token,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? id,
    String? farmId,
    String? farmName,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phoneNumber,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      token: token ?? this.token,
    );
  }
}
