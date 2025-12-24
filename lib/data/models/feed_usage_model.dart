import '../../domain/entities/feed_usage.dart';

class FeedUsageModel {
  final String farmId;
  final String userId;
  final int feedUsageId;
  final int flockId;
  final DateTime usageDate;
  final String feedType;
  final double quantityKg;

  FeedUsageModel({
    required this.farmId,
    required this.userId,
    required this.feedUsageId,
    required this.flockId,
    required this.usageDate,
    required this.feedType,
    required this.quantityKg,
  });

  factory FeedUsageModel.fromJson(Map<String, dynamic> json) {
    return FeedUsageModel(
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

  FeedUsage toEntity() {
    return FeedUsage(
      farmId: farmId,
      userId: userId,
      feedUsageId: feedUsageId,
      flockId: flockId,
      usageDate: usageDate,
      feedType: feedType,
      quantityKg: quantityKg,
    );
  }

  factory FeedUsageModel.fromEntity(FeedUsage entity) {
    return FeedUsageModel(
      farmId: entity.farmId,
      userId: entity.userId,
      feedUsageId: entity.feedUsageId,
      flockId: entity.flockId,
      usageDate: entity.usageDate,
      feedType: entity.feedType,
      quantityKg: entity.quantityKg,
    );
  }
}
