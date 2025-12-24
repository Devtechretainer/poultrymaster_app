import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? customerId;
  final String farmId;
  final String userId;
  final String name;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? city;
  final DateTime? createdDate;

  const Customer({
    this.customerId,
    required this.farmId,
    required this.userId,
    required this.name,
    this.contactEmail,
    this.contactPhone,
    this.address,
    this.city,
    this.createdDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customerId'],
      farmId: json['farmId'],
      userId: json['userId'],
      name: json['name'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      address: json['address'],
      city: json['city'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'farmId': farmId,
      'userId': userId,
      'name': name,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'address': address,
      'city': city,
      'createdDate': createdDate?.toIso8601String(),
    };
  }

  Customer copyWith({
    int? customerId,
    String? farmId,
    String? userId,
    String? name,
    String? contactEmail,
    String? contactPhone,
    String? address,
    String? city,
    DateTime? createdDate,
  }) {
    return Customer(
      customerId: customerId ?? this.customerId,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      contactEmail: contactEmail ?? this.contactEmail,
      contactPhone: contactPhone ?? this.contactPhone,
      address: address ?? this.address,
      city: city ?? this.city,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  String toString() {
    return 'Customer(customerId: $customerId, farmId: $farmId, userId: $userId, name: $name, contactEmail: $contactEmail, contactPhone: $contactPhone, address: $address, city: $city, createdDate: $createdDate)';
  }

  @override
  List<Object?> get props => [
        customerId,
        farmId,
        userId,
        name,
        contactEmail,
        contactPhone,
        address,
        city,
        createdDate,
      ];
}
