import 'package:equatable/equatable.dart';

class House extends Equatable {
  final String userId;
  final String farmId;
  final int houseId;
  final String houseName;
  final int capacity;
  final String location;

  const House({
    required this.userId,
    required this.farmId,
    required this.houseId,
    required this.houseName,
    required this.capacity,
    required this.location,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
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

  House copyWith({
    String? userId,
    String? farmId,
    int? houseId,
    String? houseName,
    int? capacity,
    String? location,
  }) {
    return House(
      userId: userId ?? this.userId,
      farmId: farmId ?? this.farmId,
      houseId: houseId ?? this.houseId,
      houseName: houseName ?? this.houseName,
      capacity: capacity ?? this.capacity,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        farmId,
        houseId,
        houseName,
        capacity,
        location,
      ];
}
