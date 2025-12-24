import '../../domain/entities/house.dart';

class HouseModel {
  final String userId;
  final String farmId;
  final int houseId;
  final String houseName;
  final int capacity;
  final String location;

  HouseModel({
    required this.userId,
    required this.farmId,
    required this.houseId,
    required this.houseName,
    required this.capacity,
    required this.location,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) {
    return HouseModel(
      userId: json['userId'] as String? ?? '',
      farmId: json['farmId'] as String? ?? '',
      houseId: json['houseId'] as int? ?? 0,
      houseName: json['houseName'] as String? ?? '',
      capacity: json['capacity'] as int? ?? 0,
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'farmId': farmId,
      'houseId': houseId,
      'houseName': houseName,
      'capacity': capacity,
      'location': location,
    };
  }

  House toEntity() {
    return House(
      userId: userId,
      farmId: farmId,
      houseId: houseId,
      houseName: houseName,
      capacity: capacity,
      location: location,
    );
  }

  factory HouseModel.fromEntity(House entity) {
    return HouseModel(
      userId: entity.userId,
      farmId: entity.farmId,
      houseId: entity.houseId,
      houseName: entity.houseName,
      capacity: entity.capacity,
      location: entity.location,
    );
  }
}
