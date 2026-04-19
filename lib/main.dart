import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quiz_app/firebase_options.dart';
import 'core/auth/auth_bloc.dart';
import 'core/locale/app_localizations.dart';
import 'core/locale/locale_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/daily_challenge/presentation/bloc/daily_challenge_bloc.dart';
import 'features/home/presentation/bloc/category_bloc.dart';
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
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => LocaleBloc()),
        BlocProvider(create: (_) => HomeBloc()..add(LoadHomeData())),
        BlocProvider(create: (_) => ProgressBloc()..add(LoadProgressData())),
        BlocProvider(create: (_) => DailyChallengeBloc()..add(LoadDailyChallenge())),
        BlocProvider(create: (_) => CategoryBloc()..add(LoadCategories())),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        // Reload progress and daily challenge whenever auth state changes
        listener: (context, authState) {
          context.read<ProgressBloc>().add(LoadProgressData());
          context.read<DailyChallengeBloc>().add(LoadDailyChallenge());
        },
        child: BlocListener<LocaleBloc, LocaleState>(
          listener: (context, localeState) {
            context.read<CategoryBloc>().add(RetryLoadCategories());
          },
          child: BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Quizora',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.darkTheme,
                locale: localeState.locale,
                supportedLocales: const [Locale('en'), Locale('fa')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: const MainNavigation(),
              );
            },
          ),
        ),
      ),
    );
  }
}
