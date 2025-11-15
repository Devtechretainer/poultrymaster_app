import '../../domain/entities/user.dart';

/// Data model - Maps between domain entity and API/storage format
class UserModel {
  final String id;
  final String? farmId;
  final String farmName;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String? token;

  UserModel({
    required this.id,
    this.farmId,
    required this.farmName,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.token,
  });

  /// Convert domain entity to data model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      farmId: user.farmId,
      farmName: user.farmName,
      firstName: user.firstName,
      lastName: user.lastName,
      username: user.username,
      email: user.email,
      phoneNumber: user.phoneNumber,
      token: user.token,
    );
  }

  /// Convert data model to domain entity
  User toEntity() {
    return User(
      id: id,
      farmId: farmId ?? id, // Use id as fallback if farmId not provided
      farmName: farmName,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      token: token,
    );
  }

  /// Convert to JSON for storage/API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (farmId != null) 'farmId': farmId,
      'farmName': farmName,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      if (token != null) 'token': token,
    };
  }

  /// Create from JSON (API response)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response structures
    // The API might return data directly or nested in 'response' or 'data'
    final id = json['id'] as String? ?? json['userId'] as String? ?? '';
    final farmId = json['farmId'] as String? ?? id; // Use id as fallback
    final farmName = json['farmName'] as String? ?? '';
    final firstName = json['firstName'] as String? ?? '';
    final lastName = json['lastName'] as String? ?? '';
    final username = json['username'] as String? ?? '';
    final email = json['email'] as String? ?? '';
    final phoneNumber = json['phoneNumber'] as String? ?? '';

    // Token might be nested in accessToken.token
    String? token;
    if (json['token'] != null) {
      token = json['token'] as String?;
    } else if (json['accessToken'] != null) {
      final accessToken = json['accessToken'];
      if (accessToken is Map<String, dynamic>) {
        token = accessToken['token'] as String?;
      } else if (accessToken is String) {
        token = accessToken;
      }
    }

    return UserModel(
      id: id,
      farmId: farmId,
      farmName: farmName,
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      token: token,
    );
  }
}
