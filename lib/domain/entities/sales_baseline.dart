import 'package:equatable/equatable.dart';

class SalesBaseline extends Equatable {
  final String id;
  final String cookstoveNumber;
  final String buyerName;
  final String status; // "Sent" or "Pending"
  final String? farmId;
  final String? userId;
  final DateTime? createdDate;

  const SalesBaseline({
    required this.id,
    required this.cookstoveNumber,
    required this.buyerName,
    required this.status,
    this.farmId,
    this.userId,
    this.createdDate,
  });

  factory SalesBaseline.fromJson(Map<String, dynamic> json) {
    return SalesBaseline(
      id: json['id'] as String? ?? '',
      cookstoveNumber: json['cookstoveNumber'] as String? ?? '',
      buyerName: json['buyerName'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      farmId: json['farmId'] as String?,
      userId: json['userId'] as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cookstoveNumber': cookstoveNumber,
      'buyerName': buyerName,
      'status': status,
      'farmId': farmId,
      'userId': userId,
      'createdDate': createdDate?.toIso8601String(),
    };
  }

  SalesBaseline copyWith({
    String? id,
    String? cookstoveNumber,
    String? buyerName,
    String? status,
    String? farmId,
    String? userId,
    DateTime? createdDate,
  }) {
    return SalesBaseline(
      id: id ?? this.id,
      cookstoveNumber: cookstoveNumber ?? this.cookstoveNumber,
      buyerName: buyerName ?? this.buyerName,
      status: status ?? this.status,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        cookstoveNumber,
        buyerName,
        status,
        farmId,
        userId,
        createdDate,
      ];
}

