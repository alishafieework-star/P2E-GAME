import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State of an active HTML5 game session.
class GameSessionState {
  const GameSessionState({
    this.isReady = false,
    this.isPaused = false,
    this.isMuted = false,
    this.score = 0,
    this.rewardPoints = 0,
    this.isGameOver = false,
    this.errorMessage,
  });

  final bool isReady;
  final bool isPaused;
  final bool isMuted;
  final int score;
  final int rewardPoints;
  final bool isGameOver;
  final String? errorMessage;

  GameSessionState copyWith({
    bool? isReady,
    bool? isPaused,
    bool? isMuted,
    int? score,
    int? rewardPoints,
    bool? isGameOver,
    String? errorMessage,
  }) {
    return GameSessionState(
      isReady: isReady ?? this.isReady,
      isPaused: isPaused ?? this.isPaused,
      isMuted: isMuted ?? this.isMuted,
      score: score ?? this.score,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      isGameOver: isGameOver ?? this.isGameOver,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Manages bidirectional messaging between the HTML5 stage and Flutter.
class GameBridgeController extends Notifier<GameSessionState> {
  @override
  GameSessionState build() => const GameSessionState();

  void markReady() {
    state = state.copyWith(isReady: true);
  }

  void updateScore(int newScore) {
    state = state.copyWith(score: newScore);
  }

  void addReward(int points) {
    state = state.copyWith(rewardPoints: state.rewardPoints + points);
  }

  void toggleMute() {
    state = state.copyWith(isMuted: !state.isMuted);
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void setGameOver() {
    state = state.copyWith(isGameOver: true);
  }

  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  void reset() {
    state = const GameSessionState();
  }
}

final gameBridgeProvider =
    NotifierProvider.autoDispose<GameBridgeController, GameSessionState>(
      GameBridgeController.new,
    );
