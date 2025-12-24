import 'package:equatable/equatable.dart';

class MainFlockBatch extends Equatable {
  final int batchId;
  final String farmId;
  final String userId;
  final String batchCode;
  final String batchName;
  final String breed;
  final int numberOfBirds;
  final DateTime startDate;
  final DateTime createdDate;

  const MainFlockBatch({
    required this.batchId,
    required this.farmId,
    required this.userId,
    required this.batchCode,
    required this.batchName,
    required this.breed,
    required this.numberOfBirds,
    required this.startDate,
    required this.createdDate,
  });

  factory MainFlockBatch.fromJson(Map<String, dynamic> json) {
    return MainFlockBatch(
      batchId: json['batchId'],
      farmId: json['farmId'],
      userId: json['userId'],
      batchCode: json['batchCode'],
      batchName: json['batchName'],
      breed: json['breed'],
      numberOfBirds: json['numberOfBirds'],
      startDate: DateTime.parse(json['startDate']),
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'batchId': batchId,
      'farmId': farmId,
      'userId': userId,
      'batchCode': batchCode,
      'batchName': batchName,
      'breed': breed,
      'numberOfBirds': numberOfBirds,
      'startDate': startDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
    };
  }

  MainFlockBatch copyWith({
    int? batchId,
    String? farmId,
    String? userId,
    String? batchCode,
    String? batchName,
    String? breed,
    int? numberOfBirds,
    DateTime? startDate,
    DateTime? createdDate,
  }) {
    return MainFlockBatch(
      batchId: batchId ?? this.batchId,
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      batchCode: batchCode ?? this.batchCode,
      batchName: batchName ?? this.batchName,
      breed: breed ?? this.breed,
      numberOfBirds: numberOfBirds ?? this.numberOfBirds,
      startDate: startDate ?? this.startDate,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  List<Object?> get props => [
        batchId,
        farmId,
        userId,
        batchCode,
        batchName,
        breed,
        numberOfBirds,
        startDate,
        createdDate,
      ];
}
