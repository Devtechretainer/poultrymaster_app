import 'package:equatable/equatable.dart';

class ProductionRecord extends Equatable {
  final int id;
  final String farmId;
  final String userId;
  final String createdBy;
  final String updatedBy;
  final int ageInWeeks;
  final int ageInDays;
  final DateTime date;
  final int noOfBirds;
  final int mortality;
  final int noOfBirdsLeft;
  final double feedKg;
  final String? medication;
  final int production9AM;
  final int production12PM;
  final int production4PM;
  final int totalProduction;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int flockId;

  const ProductionRecord({
    required this.id,
    required this.farmId,
    required this.userId,
    required this.createdBy,
    required this.updatedBy,
    required this.ageInWeeks,
    required this.ageInDays,
    required this.date,
    required this.noOfBirds,
    required this.mortality,
    required this.noOfBirdsLeft,
    required this.feedKg,
    this.medication,
    required this.production9AM,
    required this.production12PM,
    required this.production4PM,
    required this.totalProduction,
    required this.createdAt,
    required this.updatedAt,
    required this.flockId,
  });

  factory ProductionRecord.fromJson(Map<String, dynamic> json) {
    return ProductionRecord(
      id: json['id'] as int? ?? 0,
      farmId: json['farmId'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      updatedBy: json['updatedBy'] as String? ?? '',
      ageInWeeks: json['ageInWeeks'] as int? ?? 0,
      ageInDays: json['ageInDays'] as int? ?? 0,
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0), // Default to epoch if null
      noOfBirds: json['noOfBirds'] as int? ?? 0,
      mortality: json['mortality'] as int? ?? 0,
      noOfBirdsLeft: json['noOfBirdsLeft'] as int? ?? 0,
      feedKg: json['feedKg'] as double? ?? 0.0,
      medication: json['medication'] as String?, // Already nullable
      production9AM: json['production9AM'] as int? ?? 0,
      production12PM: json['production12PM'] as int? ?? 0,
      production4PM: json['production4PM'] as int? ?? 0,
      totalProduction: json['totalProduction'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0), // Default to epoch if null
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0), // Default to epoch if null
      flockId: json['flockId'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmId': farmId,
      'userId': userId,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'ageInWeeks': ageInWeeks,
      'ageInDays': ageInDays,
      'date': date.toIso8601String(),
      'noOfBirds': noOfBirds,
      'mortality': mortality,
      'noOfBirdsLeft': noOfBirdsLeft,
      'feedKg': feedKg,
      'medication': medication,
      'production9AM': production9AM,
      'production12PM': production12PM,
      'production4PM': production4PM,
      'totalProduction': totalProduction,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'flockId': flockId,
    };
  }

  ProductionRecord copyWith({
    int? id,
    String? farmId,
    String? userId,
    String? createdBy,
    String? updatedBy,
    int? ageInWeeks,
    int? ageInDays,
    DateTime? date,
    int? noOfBirds,
    int? mortality,
    int? noOfBirdsLeft,
    double? feedKg,
    String? medication,
    int? production9AM,
    int? production12PM,
    int? production4PM,
    int? totalProduction,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? flockId,
  }) {
    return ProductionRecord(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      ageInWeeks: ageInWeeks ?? this.ageInWeeks,
      ageInDays: ageInDays ?? this.ageInDays,
      date: date ?? this.date,
      noOfBirds: noOfBirds ?? this.noOfBirds,
      mortality: mortality ?? this.mortality,
      noOfBirdsLeft: noOfBirdsLeft ?? this.noOfBirdsLeft,
      feedKg: feedKg ?? this.feedKg,
      medication: medication ?? this.medication,
      production9AM: production9AM ?? this.production9AM,
      production12PM: production12PM ?? this.production12PM,
      production4PM: production4PM ?? this.production4PM,
      totalProduction: totalProduction ?? this.totalProduction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      flockId: flockId ?? this.flockId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        farmId,
        userId,
        createdBy,
        updatedBy,
        ageInWeeks,
        ageInDays,
        date,
        noOfBirds,
        mortality,
        noOfBirdsLeft,
        feedKg,
        medication,
        production9AM,
        production12PM,
        production4PM,
        totalProduction,
        createdAt,
        updatedAt,
        flockId,
      ];
}
