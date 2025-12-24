import 'package:equatable/equatable.dart';

class Flock extends Equatable {
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

  const Flock({
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

  factory Flock.fromJson(Map<String, dynamic> json) {
    return Flock(
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

  Flock copyWith({
    String? farmId,
    String? userId,
    int? flockId,
    String? name,
    String? breed,
    DateTime? startDate,
    int? quantity,
    bool? active,
    int? houseId,
    String? inactivationReason,
    String? otherReason,
    int? batchId,
    String? notes,
    String? batchName,
  }) {
    return Flock(
      farmId: farmId ?? this.farmId,
      userId: userId ?? this.userId,
      flockId: flockId ?? this.flockId,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      startDate: startDate ?? this.startDate,
      quantity: quantity ?? this.quantity,
      active: active ?? this.active,
      houseId: houseId ?? this.houseId,
      inactivationReason: inactivationReason ?? this.inactivationReason,
      otherReason: otherReason ?? this.otherReason,
      batchId: batchId ?? this.batchId,
      notes: notes ?? this.notes,
      batchName: batchName ?? this.batchName,
    );
  }

  @override
  String toString() {
    return 'Flock(farmId: $farmId, userId: $userId, flockId: $flockId, name: $name, breed: $breed, startDate: $startDate, quantity: $quantity, active: $active, houseId: $houseId, inactivationReason: $inactivationReason, otherReason: $otherReason, batchId: $batchId, notes: $notes, batchName: $batchName)';
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
        inactivationReason,
        otherReason,
        batchId,
        notes,
        batchName,
      ];
}
