import '../../domain/entities/egg_production.dart';

class EggProductionState {
  final List<EggProduction> eggProductions;
  final bool isLoading;
  final String? error;

  const EggProductionState({
    this.eggProductions = const [],
    this.isLoading = false,
    this.error,
  });

  EggProductionState copyWith({
    List<EggProduction>? eggProductions,
    bool? isLoading,
    String? error,
  }) {
    return EggProductionState(
      eggProductions: eggProductions ?? this.eggProductions,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
