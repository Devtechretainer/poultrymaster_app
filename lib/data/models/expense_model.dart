import '../../domain/entities/expense.dart';

class ExpenseModel {
  final String farmId;
  final String userId;
  final int expenseId;
  final DateTime expenseDate;
  final String category;
  final String? description;
  final double amount;
  final String paymentMethod;
  final int flockId;
  final DateTime createdDate;

  ExpenseModel({
    required this.farmId,
    required this.userId,
    required this.expenseId,
    required this.expenseDate,
    required this.category,
    this.description,
    required this.amount,
    required this.paymentMethod,
    required this.flockId,
    required this.createdDate,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      expenseId: (json['expenseId'] as num?)?.toInt() ?? 0,
      expenseDate: json['expenseDate'] != null
          ? DateTime.parse(json['expenseDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      category: json['category'] as String? ?? '',
      description: json['description'] as String?,
      amount: json['amount'] as double? ?? 0.0,
      paymentMethod: json['paymentMethod'] as String? ?? '',
      flockId: (json['flockId'] as num?)?.toInt() ?? 0,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'expenseId': expenseId,
      'expenseDate': expenseDate.toIso8601String(),
      'category': category,
      'description': description,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'flockId': flockId,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  Expense toEntity() {
    return Expense(
      farmId: farmId,
      userId: userId,
      expenseId: expenseId,
      expenseDate: expenseDate,
      category: category,
      description: description,
      amount: amount,
      paymentMethod: paymentMethod,
      flockId: flockId,
      createdDate: createdDate,
    );
  }

  factory ExpenseModel.fromEntity(Expense entity) {
    return ExpenseModel(
      farmId: entity.farmId,
      userId: entity.userId,
      expenseId: entity.expenseId,
      expenseDate: entity.expenseDate,
      category: entity.category,
      description: entity.description,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
      flockId: entity.flockId,
      createdDate: entity.createdDate,
    );
  }
}
