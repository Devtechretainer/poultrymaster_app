import '../../domain/entities/flock.dart';

class FlockState {
  final List<Flock> flocks;
  final bool isLoading;
  final String? error;

  const FlockState({
    this.flocks = const [],
    this.isLoading = false,
    this.error,
  });

  FlockState copyWith({
    List<Flock>? flocks,
    bool? isLoading,
    String? error,
  }) {
    return FlockState(
      flocks: flocks ?? this.flocks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
