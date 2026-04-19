import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_service.dart';
import '../../data/progress_repository.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();
  @override
  List<Object?> get props => [];
}

class LoadProgressData extends ProgressEvent {}

class SaveProgressData extends ProgressEvent {}

// ── States ────────────────────────────────────────────────────────────────────

abstract class ProgressState extends Equatable {
  const ProgressState();
  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressLoaded extends ProgressState {
  final int currentCredits;
  final int maxCredits;
  final int currentLevel;
  final int maxLevel;
  final List<String> achievements;
  final Map<String, double> milestones;
  final bool isSynced; // true = loaded from Firestore

  const ProgressLoaded({
    required this.currentCredits,
    required this.maxCredits,
    required this.currentLevel,
    required this.maxLevel,
    required this.achievements,
    required this.milestones,
    this.isSynced = false,
  });

  @override
  List<Object?> get props => [
        currentCredits, maxCredits, currentLevel,
        maxLevel, achievements, milestones, isSynced,
      ];
}

class ProgressSaving extends ProgressState {}

class ProgressSaved extends ProgressState {}

class ProgressError extends ProgressState {
  final String message;
  const ProgressError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressRepository _repo;

  ProgressBloc({ProgressRepository? repository})
      : _repo = repository ?? ProgressRepository(),
        super(ProgressInitial()) {
    on<LoadProgressData>(_onLoad);
    on<SaveProgressData>(_onSave);
  }

  Future<void> _onLoad(
      LoadProgressData event, Emitter<ProgressState> emit) async {
    emit(ProgressLoading());

    final user = AuthService.instance.currentUser;

    if (user != null) {
      // ── Signed in: load from Firestore ──────────────────────────────────
      try {
        final data = await _repo.load(user.uid);
        emit(ProgressLoaded(
          currentCredits: data.currentCredits,
          maxCredits: data.maxCredits,
          currentLevel: data.currentLevel,
          maxLevel: data.maxLevel,
          achievements: data.unlockedRewards,
          milestones: data.milestones,
          isSynced: true,
        ));
        return;
      } catch (_) {
        // Fall through to local fallback
      }
    }

    // ── Not signed in or Firestore failed: use local defaults ────────────
    await Future.delayed(const Duration(milliseconds: 400));
    const int currentCredits = 750;
    const int creditsPerLevel = 200;
    const int level = (currentCredits ~/ creditsPerLevel) + 1;

    emit(const ProgressLoaded(
      currentCredits: currentCredits,
      maxCredits: 1200,
      currentLevel: level,
      maxLevel: 6,
      achievements: ['Early Bird', 'Quick Thinker', 'Perfect Score'],
      milestones: {
        'credit_goal': 750 / 1200,
        'quiz_master': 0.62,
        'streak_hunter': 0.71,
      },
      isSynced: false,
    ));
  }

  Future<void> _onSave(
      SaveProgressData event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final user = AuthService.instance.currentUser;
    if (user == null) return;

    emit(ProgressSaving());
    try {
      await _repo.save(
        user.uid,
        ProgressData(
          currentCredits: current.currentCredits,
          maxCredits: current.maxCredits,
          currentLevel: current.currentLevel,
          maxLevel: current.maxLevel,
          unlockedRewards: current.achievements,
          milestones: current.milestones,
        ),
      );
      emit(ProgressSaved());
      // Reload to confirm
      add(LoadProgressData());
    } catch (e) {
      emit(ProgressError(e.toString()));
      emit(current); // restore previous state
    }
  }
}
