import 'package:equatable/equatable.dart';

class FlockBatchRequest extends Equatable {
  final String farmId;
  final String userId;
  final String batchCode;
  final String batchName;
  final String breed;
  final int numberOfBirds;
  final DateTime startDate;

  const FlockBatchRequest({
    required this.farmId,
    required this.userId,
    required this.batchCode,
    required this.batchName,
    required this.breed,
    required this.numberOfBirds,
    required this.startDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'batchCode': batchCode,
      'batchName': batchName,
      'breed': breed,
      'numberOfBirds': numberOfBirds,
      'startDate': startDate.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        farmId,
        userId,
        batchCode,
        batchName,
        breed,
        numberOfBirds,
        startDate,
      ];
}
