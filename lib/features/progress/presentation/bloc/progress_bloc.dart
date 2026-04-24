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

class AddCredits extends ProgressEvent {
  final int credits;
  const AddCredits(this.credits);
  @override
  List<Object?> get props => [credits];
}

class RecordQuizCompletion extends ProgressEvent {}

class UpdateStreak extends ProgressEvent {}

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
  final int totalQuizzes;
  final int currentStreak;
  final DateTime? lastActivityAt;
  final DateTime? lastDailyChallengeAt;
  final bool isSynced;

  const ProgressLoaded({
    required this.currentCredits,
    required this.maxCredits,
    required this.currentLevel,
    required this.maxLevel,
    required this.achievements,
    required this.milestones,
    required this.totalQuizzes,
    required this.currentStreak,
    this.lastActivityAt,
    this.lastDailyChallengeAt,
    this.isSynced = false,
  });

  @override
  List<Object?> get props => [
        currentCredits,
        maxCredits,
        currentLevel,
        maxLevel,
        achievements,
        milestones,
        totalQuizzes,
        currentStreak,
        lastActivityAt,
        lastDailyChallengeAt,
        isSynced,
      ];

  ProgressLoaded copyWith({
    int? currentCredits,
    int? maxCredits,
    int? currentLevel,
    int? maxLevel,
    List<String>? achievements,
    Map<String, double>? milestones,
    int? totalQuizzes,
    int? currentStreak,
    DateTime? lastActivityAt,
    DateTime? lastDailyChallengeAt,
    bool? isSynced,
  }) {
    return ProgressLoaded(
      currentCredits: currentCredits ?? this.currentCredits,
      maxCredits: maxCredits ?? this.maxCredits,
      currentLevel: currentLevel ?? this.currentLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      achievements: achievements ?? this.achievements,
      milestones: milestones ?? this.milestones,
      totalQuizzes: totalQuizzes ?? this.totalQuizzes,
      currentStreak: currentStreak ?? this.currentStreak,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      lastDailyChallengeAt: lastDailyChallengeAt ?? this.lastDailyChallengeAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

class ProgressSaving extends ProgressLoaded {
  ProgressSaving(ProgressLoaded state)
      : super(
          currentCredits: state.currentCredits,
          maxCredits: state.maxCredits,
          currentLevel: state.currentLevel,
          maxLevel: state.maxLevel,
          achievements: state.achievements,
          milestones: state.milestones,
          totalQuizzes: state.totalQuizzes,
          currentStreak: state.currentStreak,
          lastActivityAt: state.lastActivityAt,
          lastDailyChallengeAt: state.lastDailyChallengeAt,
          isSynced: state.isSynced,
        );
}

class ProgressSaved extends ProgressLoaded {
  ProgressSaved(ProgressLoaded state)
      : super(
          currentCredits: state.currentCredits,
          maxCredits: state.maxCredits,
          currentLevel: state.currentLevel,
          maxLevel: state.maxLevel,
          achievements: state.achievements,
          milestones: state.milestones,
          totalQuizzes: state.totalQuizzes,
          currentStreak: state.currentStreak,
          lastActivityAt: state.lastActivityAt,
          lastDailyChallengeAt: state.lastDailyChallengeAt,
          isSynced: state.isSynced,
        );
}

class ProgressError extends ProgressLoaded {
  final String message;
  ProgressError(ProgressLoaded state, this.message)
      : super(
          currentCredits: state.currentCredits,
          maxCredits: state.maxCredits,
          currentLevel: state.currentLevel,
          maxLevel: state.maxLevel,
          achievements: state.achievements,
          milestones: state.milestones,
          totalQuizzes: state.totalQuizzes,
          currentStreak: state.currentStreak,
          lastActivityAt: state.lastActivityAt,
          lastDailyChallengeAt: state.lastDailyChallengeAt,
          isSynced: state.isSynced,
        );

  @override
  List<Object?> get props => [...super.props, message];
}

// ── Bloc ──────────────────────────────────────────────────────────────────────

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressRepository _repo;

  ProgressBloc({ProgressRepository? repository})
      : _repo = repository ?? ProgressRepository(),
        super(ProgressInitial()) {
    on<LoadProgressData>(_onLoad);
    on<SaveProgressData>(_onSave);
    on<AddCredits>(_onAddCredits);
    on<RecordQuizCompletion>(_onRecordQuizCompletion);
    on<UpdateStreak>(_onUpdateStreak);
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
          totalQuizzes: data.totalQuizzes,
          currentStreak: data.currentStreak,
          lastActivityAt: data.lastActivityAt,
          lastDailyChallengeAt: data.lastDailyChallengeAt,
          isSynced: true,
        ));
        
        // Automatically update streak on load
        add(UpdateStreak());
        return;
      } catch (_) {
        // Fall through to local fallback
      }
    }

    // ── Not signed in or Firestore failed: use local defaults (starting at 0) ────────────
    final initial = ProgressData.initial();

    emit(ProgressLoaded(
      currentCredits: initial.currentCredits,
      maxCredits: initial.maxCredits,
      currentLevel: initial.currentLevel,
      maxLevel: initial.maxLevel,
      achievements: initial.unlockedRewards,
      milestones: initial.milestones,
      totalQuizzes: initial.totalQuizzes,
      currentStreak: initial.currentStreak,
      lastActivityAt: initial.lastActivityAt,
      lastDailyChallengeAt: initial.lastDailyChallengeAt,
      isSynced: false,
    ));
  }

  Future<void> _onAddCredits(
      AddCredits event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final newCredits = current.currentCredits + event.credits;
    
    final updatedData = ProgressData(
      currentCredits: newCredits,
      maxCredits: current.maxCredits,
      currentLevel: current.currentLevel,
      maxLevel: current.maxLevel,
      unlockedRewards: current.achievements,
      milestones: current.milestones,
      totalQuizzes: current.totalQuizzes,
      currentStreak: current.currentStreak,
      lastActivityAt: current.lastActivityAt,
      lastDailyChallengeAt: current.lastDailyChallengeAt,
    ).withCredits(newCredits);

    emit(ProgressLoaded(
      currentCredits: updatedData.currentCredits,
      maxCredits: updatedData.maxCredits,
      currentLevel: updatedData.currentLevel,
      maxLevel: updatedData.maxLevel,
      achievements: updatedData.unlockedRewards,
      milestones: updatedData.milestones,
      totalQuizzes: updatedData.totalQuizzes,
      currentStreak: updatedData.currentStreak,
      lastActivityAt: updatedData.lastActivityAt,
      lastDailyChallengeAt: updatedData.lastDailyChallengeAt,
      isSynced: current.isSynced,
    ));

    // If signed in, also save to database
    final user = AuthService.instance.currentUser;
    if (user != null) {
      add(SaveProgressData());
    }
  }

  Future<void> _onRecordQuizCompletion(
      RecordQuizCompletion event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final updatedData = ProgressData(
      currentCredits: current.currentCredits,
      maxCredits: current.maxCredits,
      currentLevel: current.currentLevel,
      maxLevel: current.maxLevel,
      unlockedRewards: current.achievements,
      milestones: current.milestones,
      totalQuizzes: current.totalQuizzes,
      currentStreak: current.currentStreak,
      lastActivityAt: current.lastActivityAt,
      lastDailyChallengeAt: current.lastDailyChallengeAt,
    ).withQuizCompletion();

    emit(ProgressLoaded(
      currentCredits: updatedData.currentCredits,
      maxCredits: updatedData.maxCredits,
      currentLevel: updatedData.currentLevel,
      maxLevel: updatedData.maxLevel,
      achievements: updatedData.unlockedRewards,
      milestones: updatedData.milestones,
      totalQuizzes: updatedData.totalQuizzes,
      currentStreak: updatedData.currentStreak,
      lastActivityAt: updatedData.lastActivityAt,
      lastDailyChallengeAt: updatedData.lastDailyChallengeAt,
      isSynced: current.isSynced,
    ));

    // Update streak as well
    add(UpdateStreak());
  }

  Future<void> _onUpdateStreak(
      UpdateStreak event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final updatedData = ProgressData(
      currentCredits: current.currentCredits,
      maxCredits: current.maxCredits,
      currentLevel: current.currentLevel,
      maxLevel: current.maxLevel,
      unlockedRewards: current.achievements,
      milestones: current.milestones,
      totalQuizzes: current.totalQuizzes,
      currentStreak: current.currentStreak,
      lastActivityAt: current.lastActivityAt,
      lastDailyChallengeAt: current.lastDailyChallengeAt,
    ).withStreakUpdate();

    emit(ProgressLoaded(
      currentCredits: updatedData.currentCredits,
      maxCredits: updatedData.maxCredits,
      currentLevel: updatedData.currentLevel,
      maxLevel: updatedData.maxLevel,
      achievements: updatedData.unlockedRewards,
      milestones: updatedData.milestones,
      totalQuizzes: updatedData.totalQuizzes,
      currentStreak: updatedData.currentStreak,
      lastActivityAt: updatedData.lastActivityAt,
      lastDailyChallengeAt: updatedData.lastDailyChallengeAt,
      isSynced: current.isSynced,
    ));

    final user = AuthService.instance.currentUser;
    if (user != null) {
      add(SaveProgressData());
    }
  }

  Future<void> _onSave(
      SaveProgressData event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final user = AuthService.instance.currentUser;
    if (user == null) return;

    emit(ProgressSaving(current));
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
          totalQuizzes: current.totalQuizzes,
          currentStreak: current.currentStreak,
          lastActivityAt: current.lastActivityAt,
          lastDailyChallengeAt: current.lastDailyChallengeAt,
        ),
      );
      emit(ProgressSaved(current));
    } catch (e) {
      emit(ProgressError(current, e.toString()));
    }
  }
}
