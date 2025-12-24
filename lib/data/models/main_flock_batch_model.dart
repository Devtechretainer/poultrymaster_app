import '../../domain/entities/main_flock_batch.dart';

class MainFlockBatchModel {
  final int batchId;
  final String farmId;
  final String userId;
  final String batchCode;
  final String batchName;
  final String breed;
  final int numberOfBirds;
  final DateTime startDate;
  final DateTime createdDate;

  MainFlockBatchModel({
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

  factory MainFlockBatchModel.fromJson(Map<String, dynamic> json) {
    return MainFlockBatchModel(
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

  MainFlockBatch toEntity() {
    return MainFlockBatch(
      batchId: batchId,
      farmId: farmId,
      userId: userId,
      batchCode: batchCode,
      batchName: batchName,
      breed: breed,
      numberOfBirds: numberOfBirds,
      startDate: startDate,
      createdDate: createdDate,
    );
  }

  factory MainFlockBatchModel.fromEntity(MainFlockBatch entity) {
    return MainFlockBatchModel(
      batchId: entity.batchId,
      farmId: entity.farmId,
      userId: entity.userId,
      batchCode: entity.batchCode,
      batchName: entity.batchName,
      breed: entity.breed,
      numberOfBirds: entity.numberOfBirds,
      startDate: entity.startDate,
      createdDate: entity.createdDate,
    );
  }
}
