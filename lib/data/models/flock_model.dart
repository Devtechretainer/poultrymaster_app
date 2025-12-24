import '../../domain/entities/flock.dart';

class FlockModel {
  final String farmId;
  final String userId;
  final int flockId;
  final String name;
  final String breed;
  final DateTime startDate;
  final int quantity;
  final bool active;
  final int? houseId;
  final String? inactivationReason;
  final String? otherReason;
  final int batchId;
  final String? notes;
  final String? batchName;

  FlockModel({
    required this.farmId,
    required this.userId,
    required this.flockId,
    required this.name,
    required this.breed,
    required this.startDate,
    required this.quantity,
    required this.active,
    this.houseId,
    this.inactivationReason,
    this.otherReason,
    required this.batchId,
    this.notes,
    this.batchName,
  });

  factory FlockModel.fromJson(Map<String, dynamic> json) {
    return FlockModel(
      farmId: json['farmId'],
      userId: json['userId'],
      flockId: json['flockId'],
      name: json['name'],
      breed: json['breed'],
      startDate: DateTime.parse(json['startDate']),
      quantity: json['quantity'],
      active: json['active'],
      houseId: json['houseId'],
      inactivationReason: json['inactivationReason'],
      otherReason: json['otherReason'],
      batchId: json['batchId'],
      notes: json['notes'],
      batchName: json['batchName'],
    );
  }

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
      'inactivationReason': inactivationReason,
      'otherReason': otherReason,
      'batchId': batchId,
      'notes': notes,
      'batchName': batchName,
    };
  }

  Flock toEntity() {
    return Flock(
      farmId: farmId,
      userId: userId,
      flockId: flockId,
      name: name,
      breed: breed,
      startDate: startDate,
      quantity: quantity,
      active: active,
      houseId: houseId,
      inactivationReason: inactivationReason,
      otherReason: otherReason,
      batchId: batchId,
      notes: notes,
      batchName: batchName,
    );
  }

  factory FlockModel.fromEntity(Flock flock) {
    return FlockModel(
      farmId: flock.farmId,
      userId: flock.userId,
      flockId: flock.flockId,
      name: flock.name,
      breed: flock.breed,
      startDate: flock.startDate,
      quantity: flock.quantity,
      active: flock.active,
      houseId: flock.houseId,
      inactivationReason: flock.inactivationReason,
      otherReason: flock.otherReason,
      batchId: flock.batchId,
      notes: flock.notes,
      batchName: flock.batchName,
    );
  }
}
