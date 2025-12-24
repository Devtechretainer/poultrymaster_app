import 'package:equatable/equatable.dart';

class FeedUsage extends Equatable {
  final String farmId;
  final String userId;
  final int feedUsageId;
  final int flockId;
  final DateTime usageDate;
  final String feedType;
  final double quantityKg;

  const FeedUsage({
    required this.farmId,
    required this.userId,
    required this.feedUsageId,
    required this.flockId,
    required this.usageDate,
    required this.feedType,
    required this.quantityKg,
  });

  factory FeedUsage.fromJson(Map<String, dynamic> json) {
    return FeedUsage(
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      feedUsageId: json['feedUsageId'] as int? ?? 0,
      flockId: json['flockId'] as int? ?? 0,
      usageDate: json['usageDate'] != null
          ? DateTime.parse(json['usageDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      feedType: json['feedType'] as String? ?? '',
      quantityKg: json['quantityKg'] as double? ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'feedUsageId': feedUsageId,
      'flockId': flockId,
      'usageDate': usageDate.toIso8601String(),
      'feedType': feedType,
      'quantityKg': quantityKg,
    };
  }

  FeedUsage copyWith({
    String? farmId,
    String? userId,
    int? feedUsageId,
    int? flockId,
    DateTime? usageDate,
    String? feedType,
    double? quantityKg,
  }) {
    return FeedUsage(
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      feedUsageId: feedUsageId ?? this.feedUsageId,
      flockId: flockId ?? this.flockId,
      usageDate: usageDate ?? this.usageDate,
      feedType: feedType ?? this.feedType,
      quantityKg: quantityKg ?? this.quantityKg,
    );
  }

  @override
  List<Object?> get props => [
        farmId,
        userId,
        feedUsageId,
        flockId,
        usageDate,
        feedType,
        quantityKg,
      ];
}
