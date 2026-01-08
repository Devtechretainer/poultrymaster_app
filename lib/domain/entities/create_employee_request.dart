class CreateEmployeeRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String userName;
  final String password;
  final String farmId;
  final String farmName;

  CreateEmployeeRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.userName,
    required this.password,
    required this.farmId,
    required this.farmName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'password': password,
      'farmId': farmId,
      'farmName': farmName,
    };
  }
}
