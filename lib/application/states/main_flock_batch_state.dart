import '../../domain/entities/main_flock_batch.dart';

class MainFlockBatchState {
  final List<MainFlockBatch> mainFlockBatches;
  final bool isLoading;
  final String? error;

  const MainFlockBatchState({
    this.mainFlockBatches = const [],
    this.isLoading = false,
    this.error,
  });

  MainFlockBatchState copyWith({
    List<MainFlockBatch>? mainFlockBatches,
    bool? isLoading,
    String? error,
  }) {
    return MainFlockBatchState(
      mainFlockBatches: mainFlockBatches ?? this.mainFlockBatches,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
