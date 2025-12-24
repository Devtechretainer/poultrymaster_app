import '../../domain/entities/customer.dart';

/// Data model - Customer API response model
class CustomerModel {
  final int? customerId;
  final String farmId;
  final String userId;
  final String name;
  final String? contactEmail;
  final String? contactPhone;
  final String? address;
  final String? city;
  final DateTime? createdDate;

  CustomerModel({
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

  /// Convert from JSON
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customerId'] as int?,
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      if (customerId != null) 'customerId': customerId,
      'farmId': farmId,
      'userId': userId,
      'name': name,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (contactPhone != null) 'contactPhone': contactPhone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (createdDate != null) 'createdDate': createdDate!.toIso8601String(),
    };
  }

  /// Convert to domain entity
  Customer toEntity() {
    return Customer(
      customerId: customerId,
      farmId: farmId,
      userId: userId,
      name: name,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      address: address,
      city: city,
      createdDate: createdDate,
    );
  }

  /// Create from domain entity
  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      customerId: customer.customerId,
      farmId: customer.farmId,
      userId: customer.userId,
      name: customer.name,
      contactEmail: customer.contactEmail,
      contactPhone: customer.contactPhone,
      address: customer.address,
      city: customer.city,
      createdDate: customer.createdDate,
    );
  }
}
