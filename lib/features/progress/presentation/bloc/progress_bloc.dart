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
    on<AddCredits>(_onAddCredits);
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

    // ── Not signed in or Firestore failed: use local defaults (starting at 0) ────────────
    final initial = ProgressData.initial();

    emit(ProgressLoaded(
      currentCredits: initial.currentCredits,
      maxCredits: initial.maxCredits,
      currentLevel: initial.currentLevel,
      maxLevel: initial.maxLevel,
      achievements: initial.unlockedRewards,
      milestones: initial.milestones,
      isSynced: false,
    ));
  }

  Future<void> _onAddCredits(
      AddCredits event, Emitter<ProgressState> emit) async {
    final current = state;
    if (current is! ProgressLoaded) return;

    final newCredits = current.currentCredits + event.credits;
    
    // Create new data using ProgressData logic for level-ups
    final initial = ProgressData.initial(); // for defaults
    final updatedData = ProgressData(
      currentCredits: newCredits,
      maxCredits: current.maxCredits,
      currentLevel: current.currentLevel,
      maxLevel: current.maxLevel,
      unlockedRewards: current.achievements,
      milestones: current.milestones,
    ).withCredits(newCredits);

    emit(ProgressLoaded(
      currentCredits: updatedData.currentCredits,
      maxCredits: updatedData.maxCredits,
      currentLevel: updatedData.currentLevel,
      maxLevel: updatedData.maxLevel,
      achievements: updatedData.unlockedRewards,
      milestones: updatedData.milestones,
      isSynced: current.isSynced,
    ));

    // If signed in, also save to database
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
