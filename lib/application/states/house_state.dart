import '../../domain/entities/house.dart';

class HouseState {
  final List<House> houses;
  final bool isLoading;
  final String? error;

  const HouseState({
    this.houses = const [],
    this.isLoading = false,
    this.error,
  });

  HouseState copyWith({
    List<House>? houses,
    bool? isLoading,
    String? error,
  }) {
    return HouseState(
      houses: houses ?? this.houses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
