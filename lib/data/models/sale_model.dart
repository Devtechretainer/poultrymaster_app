import '../../domain/entities/sale.dart';

class SaleModel {
  final String farmId;
  final String userId;
  final int saleId;
  final DateTime saleDate;
  final String product;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final String paymentMethod;
  final String customerName;
  final int flockId;
  final String? saleDescription;
  final DateTime createdDate;

  SaleModel({
    required this.farmId,
    required this.userId,
    required this.saleId,
    required this.saleDate,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customerName,
    required this.flockId,
    this.saleDescription,
    required this.createdDate,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      saleId: (json['saleId'] as num?)?.toInt() ?? 0,
      saleDate: json['saleDate'] != null
          ? DateTime.parse(json['saleDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      product: json['product'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPrice: json['unitPrice'] as double? ?? 0.0,
      totalAmount: json['totalAmount'] as double? ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      flockId: (json['flockId'] as num?)?.toInt() ?? 0,
      saleDescription: json['saleDescription'] as String?,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'saleId': saleId,
      'saleDate': saleDate.toIso8601String(),
      'product': product,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'customerName': customerName,
      'flockId': flockId,
      'saleDescription': saleDescription,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  Sale toEntity() {
    return Sale(
      farmId: farmId,
      userId: userId,
      saleId: saleId,
      saleDate: saleDate,
      product: product,
      quantity: quantity,
      unitPrice: unitPrice,
      totalAmount: totalAmount,
      paymentMethod: paymentMethod,
      customerName: customerName,
      flockId: flockId,
      saleDescription: saleDescription,
      createdDate: createdDate,
    );
  }

  factory SaleModel.fromEntity(Sale entity) {
    return SaleModel(
      farmId: entity.farmId,
      userId: entity.userId,
      saleId: entity.saleId,
      saleDate: entity.saleDate,
      product: entity.product,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalAmount: entity.totalAmount,
      paymentMethod: entity.paymentMethod,
      customerName: entity.customerName,
      flockId: entity.flockId,
      saleDescription: entity.saleDescription,
      createdDate: entity.createdDate,
    );
  }
}
