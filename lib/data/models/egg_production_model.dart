import '../../domain/entities/egg_production.dart';

class EggProductionModel {
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

  EggProductionModel({
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

  factory EggProductionModel.fromJson(Map<String, dynamic> json) {
    return EggProductionModel(
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

  EggProduction toEntity() {
    return EggProduction(
      farmId: farmId,
      userId: userId,
      productionId: productionId,
      flockId: flockId,
      productionDate: productionDate,
      eggCount: eggCount,
      production9AM: production9AM,
      production12PM: production12PM,
      production4PM: production4PM,
      totalProduction: totalProduction,
      brokenEggs: brokenEggs,
      notes: notes,
    );
  }

  factory EggProductionModel.fromEntity(EggProduction entity) {
    return EggProductionModel(
      farmId: entity.farmId,
      userId: entity.userId,
      productionId: entity.productionId,
      flockId: entity.flockId,
      productionDate: entity.productionDate,
      eggCount: entity.eggCount,
      production9AM: entity.production9AM,
      production12PM: entity.production12PM,
      production4PM: entity.production4PM,
      totalProduction: entity.totalProduction,
      brokenEggs: entity.brokenEggs,
      notes: entity.notes,
    );
  }
}
