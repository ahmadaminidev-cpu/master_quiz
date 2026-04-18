import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class DailyChallengeEvent extends Equatable {
  const DailyChallengeEvent();
  @override
  List<Object?> get props => [];
}

class LoadDailyChallenge extends DailyChallengeEvent {}

class CompleteDailyChallenge extends DailyChallengeEvent {
  final int score;
  const CompleteDailyChallenge(this.score);
  @override
  List<Object?> get props => [score];
}

// ── States ────────────────────────────────────────────────────────────────────

abstract class DailyChallengeState extends Equatable {
  const DailyChallengeState();
  @override
  List<Object?> get props => [];
}

class DailyChallengeInitial extends DailyChallengeState {}

class DailyChallengeAvailable extends DailyChallengeState {
  /// How many questions the user has already answered today (0–3).
  final int answeredCount;
  final int totalQuestions;

  const DailyChallengeAvailable({
    required this.answeredCount,
    required this.totalQuestions,
  });

  bool get isCompleted => answeredCount >= totalQuestions;
  double get progress => answeredCount / totalQuestions;

  @override
  List<Object?> get props => [answeredCount, totalQuestions];
}

class DailyChallengeCompleted extends DailyChallengeState {
  final int score;
  final int totalQuestions;

  const DailyChallengeCompleted({
    required this.score,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [score, totalQuestions];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class DailyChallengeBloc
    extends Bloc<DailyChallengeEvent, DailyChallengeState> {
  static const int totalQuestions = 3;

  DailyChallengeBloc() : super(DailyChallengeInitial()) {
    on<LoadDailyChallenge>(_onLoad);
    on<CompleteDailyChallenge>(_onComplete);
  }

  void _onLoad(LoadDailyChallenge event, Emitter<DailyChallengeState> emit) {
    // In a real app this would read from local storage / backend.
    // For now we always start fresh (0 answered).
    emit(const DailyChallengeAvailable(
      answeredCount: 0,
      totalQuestions: totalQuestions,
    ));
  }

  void _onComplete(
      CompleteDailyChallenge event, Emitter<DailyChallengeState> emit) {
    emit(DailyChallengeCompleted(
      score: event.score,
      totalQuestions: totalQuestions,
    ));
  }
}
