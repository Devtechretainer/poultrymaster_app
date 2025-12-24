import '../../domain/entities/feed_usage.dart';

class FeedUsageState {
  final List<FeedUsage> feedUsages;
  final bool isLoading;
  final String? error;

  const FeedUsageState({
    this.feedUsages = const [],
    this.isLoading = false,
    this.error,
  });

  FeedUsageState copyWith({
    List<FeedUsage>? feedUsages,
    bool? isLoading,
    String? error,
  }) {
    return FeedUsageState(
      feedUsages: feedUsages ?? this.feedUsages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
