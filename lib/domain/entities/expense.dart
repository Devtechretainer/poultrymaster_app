import 'package:equatable/equatable.dart';

class Expense extends Equatable {
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

  const Expense({
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

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
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

  Expense copyWith({
    String? farmId,
    String? userId,
    int? expenseId,
    DateTime? expenseDate,
    String? category,
    String? description,
    double? amount,
    String? paymentMethod,
    int? flockId,
    DateTime? createdDate,
  }) {
    return Expense(
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      expenseId: expenseId ?? this.expenseId,
      expenseDate: expenseDate ?? this.expenseDate,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      flockId: flockId ?? this.flockId,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  List<Object?> get props => [
        farmId,
        userId,
        expenseId,
        expenseDate,
        category,
        description,
        amount,
        paymentMethod,
        flockId,
        createdDate,
      ];
}
