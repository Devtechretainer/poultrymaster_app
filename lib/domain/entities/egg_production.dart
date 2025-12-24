import 'package:equatable/equatable.dart';

class EggProduction extends Equatable {
  final String farmId;
  final String userId;
  final int productionId;
  final int flockId;
  final DateTime productionDate;
  final int eggCount;
  final int production9AM;
  final int production12PM;
  final int production4PM;
  final int totalProduction;
  final int brokenEggs;
  final String? notes;

  const EggProduction({
    required this.farmId,
    required this.userId,
    required this.productionId,
    required this.flockId,
    required this.productionDate,
    required this.eggCount,
    required this.production9AM,
    required this.production12PM,
    required this.production4PM,
    required this.totalProduction,
    required this.brokenEggs,
    this.notes,
  });

  factory EggProduction.fromJson(Map<String, dynamic> json) {
    return EggProduction(
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      productionId: json['productionId'] as int? ?? 0,
      flockId: json['flockId'] as int? ?? 0,
      productionDate: json['productionDate'] != null
          ? DateTime.parse(json['productionDate'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      eggCount: json['eggCount'] as int? ?? 0,
      production9AM: json['production9AM'] as int? ?? 0,
      production12PM: json['production12PM'] as int? ?? 0,
      production4PM: json['production4PM'] as int? ?? 0,
      totalProduction: json['totalProduction'] as int? ?? 0,
      brokenEggs: json['brokenEggs'] as int? ?? 0,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'productionId': productionId,
      'flockId': flockId,
      'productionDate': productionDate.toIso8601String(),
      'eggCount': eggCount,
      'production9AM': production9AM,
      'production12PM': production12PM,
      'production4PM': production4PM,
      'totalProduction': totalProduction,
      'brokenEggs': brokenEggs,
      'notes': notes,
    };
  }

  EggProduction copyWith({
    String? farmId,
    String? userId,
    int? productionId,
    int? flockId,
    DateTime? productionDate,
    int? eggCount,
    int? production9AM,
    int? production12PM,
    int? production4PM,
    int? totalProduction,
    int? brokenEggs,
    String? notes,
  }) {
    return EggProduction(
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      productionId: productionId ?? this.productionId,
      flockId: flockId ?? this.flockId,
      productionDate: productionDate ?? this.productionDate,
      eggCount: eggCount ?? this.eggCount,
      production9AM: production9AM ?? this.production9AM,
      production12PM: production12PM ?? this.production12PM,
      production4PM: production4PM ?? this.production4PM,
      totalProduction: totalProduction ?? this.totalProduction,
      brokenEggs: brokenEggs ?? this.brokenEggs,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        farmId,
        userId,
        productionId,
        flockId,
        productionDate,
        eggCount,
        production9AM,
        production12PM,
        production4PM,
        totalProduction,
        brokenEggs,
        notes,
      ];
}
