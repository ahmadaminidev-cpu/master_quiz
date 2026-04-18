import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ProgressEvent extends Equatable {
  const ProgressEvent();
  @override
  List<Object?> get props => [];
}

class LoadProgressData extends ProgressEvent {}

// States
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

  const ProgressLoaded({
    required this.currentCredits,
    required this.maxCredits,
    required this.currentLevel,
    required this.maxLevel,
    required this.achievements,
  });

  @override
  List<Object?> get props => [currentCredits, maxCredits, currentLevel, maxLevel, achievements];
}

// Bloc
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc() : super(ProgressInitial()) {
    on<LoadProgressData>((event, emit) async {
      emit(ProgressLoading());
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Logic based on user idea:
      // Max Credits: 1200
      // Max Levels: 6
      // Each level: 200 credits
      const int currentCredits = 750; // Example current standing
      const int creditsPerLevel = 200;
      const int level = (currentCredits ~/ creditsPerLevel) + 1;

      emit(const ProgressLoaded(
        currentCredits: currentCredits,
        maxCredits: 1200,
        currentLevel: level,
        maxLevel: 6,
        achievements: ['Early Bird', 'Quick Thinker', 'Perfect Score'],
      ));
    });
  }
}
