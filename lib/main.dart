import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/daily_challenge/presentation/bloc/daily_challenge_bloc.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/progress/presentation/bloc/progress_bloc.dart';
import 'features/navigation/presentation/pages/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()..add(LoadHomeData())),
        BlocProvider(
          create: (context) => ProgressBloc()..add(LoadProgressData()),
        ),
        BlocProvider(
          create: (context) => DailyChallengeBloc()..add(LoadDailyChallenge()),
        ),
      ],
      child: MaterialApp(
        title: 'Quizora',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
