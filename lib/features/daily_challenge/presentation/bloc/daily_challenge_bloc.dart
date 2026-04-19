import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../progress/data/progress_repository.dart';

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
  final DateTime? nextAvailableAt;

  const DailyChallengeCompleted({
    required this.score,
    required this.totalQuestions,
    this.nextAvailableAt,
  });

  @override
  List<Object?> get props => [score, totalQuestions, nextAvailableAt];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class DailyChallengeBloc
    extends Bloc<DailyChallengeEvent, DailyChallengeState> {
  static const int totalQuestions = 3;
  final ProgressRepository _repo;

  DailyChallengeBloc({ProgressRepository? repository})
      : _repo = repository ?? ProgressRepository(),
        super(DailyChallengeInitial()) {
    on<LoadDailyChallenge>(_onLoad);
    on<CompleteDailyChallenge>(_onComplete);
  }

  Future<void> _onLoad(
      LoadDailyChallenge event, Emitter<DailyChallengeState> emit) async {
    final user = AuthService.instance.currentUser;
    DateTime? lastAt;

    if (user != null) {
      try {
        final progress = await _repo.load(user.uid);
        lastAt = progress.lastDailyChallengeAt;
      } catch (_) {}
    } else {
      // Guest user: check local storage
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('last_daily_challenge');
      if (timestamp != null) {
        lastAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    }

    if (lastAt != null) {
      final now = DateTime.now();
      final diff = now.difference(lastAt);
      if (diff.inHours < 24) {
        emit(DailyChallengeCompleted(
          score: 0,
          totalQuestions: totalQuestions,
          nextAvailableAt: lastAt.add(const Duration(hours: 24)),
        ));
        return;
      }
    }

    emit(const DailyChallengeAvailable(
      answeredCount: 0,
      totalQuestions: totalQuestions,
    ));
  }

  Future<void> _onComplete(
      CompleteDailyChallenge event, Emitter<DailyChallengeState> emit) async {
    final user = AuthService.instance.currentUser;
    final now = DateTime.now();

    if (user != null) {
      try {
        final progress = await _repo.load(user.uid);
        final updated = progress.withDailyChallenge(now);
        await _repo.save(user.uid, updated);
      } catch (_) {}
    } else {
      // Guest user: save to local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_daily_challenge', now.millisecondsSinceEpoch);
    }

    emit(DailyChallengeCompleted(
      score: event.score,
      totalQuestions: totalQuestions,
      nextAvailableAt: now.add(const Duration(hours: 24)),
    ));
  }
}
