import 'package:equatable/equatable.dart';

class FlockRequest extends Equatable {
  final String farmId;
  final String userId;
  final int? flockId; // Optional for creation, present for updates
  final String name;
  final String breed;
  final DateTime startDate;
  final int quantity;
  final bool active;
  final int? houseId;
  final int batchId; // Required as per frontend FlockInput
  final String? batchName;
  final String? inactivationReason;
  final String? otherReason;
  final String? notes;

  const FlockRequest({
    required this.farmId,
    required this.userId,
    this.flockId,
    required this.name,
    required this.breed,
    required this.startDate,
    required this.quantity,
    required this.active,
    this.houseId,
    required this.batchId,
    this.batchName,
    this.inactivationReason,
    this.otherReason,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'userId': userId,
      'flockId': flockId,
      'name': name,
      'breed': breed,
      'startDate': startDate.toIso8601String(),
      'quantity': quantity,
      'active': active,
      'houseId': houseId,
      'batchId': batchId,
      'batchName': batchName,
      'inactivationReason': inactivationReason,
      'otherReason': otherReason,
      'notes': notes,
    };
  }

  @override
  List<Object?> get props => [
        farmId,
        userId,
        flockId,
        name,
        breed,
        startDate,
        quantity,
        active,
        houseId,
        batchId,
        batchName,
        inactivationReason,
        otherReason,
        notes,
      ];
}
