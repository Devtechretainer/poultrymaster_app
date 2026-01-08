class Employee {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String userName;
  final String farmId;
  final String? farmName;
  final bool isStaff;
  final bool emailConfirmed;
  final DateTime createdDate;

  Employee({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    required this.userName,
    required this.farmId,
    this.farmName,
    required this.isStaff,
    required this.emailConfirmed,
    required this.createdDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      userName: json['userName'],
      farmId: json['farmId'],
      farmName: json['farmName'],
      isStaff: json['isStaff'],
      emailConfirmed: json['emailConfirmed'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'userName': userName,
      'farmId': farmId,
      'farmName': farmName,
      'isStaff': isStaff,
      'emailConfirmed': emailConfirmed,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  Employee copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? userName,
    String? farmId,
    String? farmName,
    bool? isStaff,
    bool? emailConfirmed,
    DateTime? createdDate,
  }) {
    return Employee(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
      farmId: farmId ?? this.farmId,
      farmName: farmName ?? this.farmName,
      isStaff: isStaff ?? this.isStaff,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}
