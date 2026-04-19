import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/auth/auth_bloc.dart';
import '../../../../core/locale/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/presentation/pages/home_screen.dart';
import '../../../progress/presentation/pages/progress_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    HomeScreen(),
    ProgressScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        _showLoginDialog();
        return;
      }
    }
    setState(() => _selectedIndex = index);
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Sign In Required',
          style: TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Sign in with Google to save your progress and sync it across devices.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthSignInRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.login_rounded, size: 18),
                SizedBox(width: 8),
                Text('Sign in with Google',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // After successful sign-in, navigate to Progress tab
        if (state is AuthAuthenticated && _selectedIndex == 0) {
          setState(() => _selectedIndex = 1);
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.mainGradient),
          child: SafeArea(
            bottom: false,
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.grid_view_rounded),
                  activeIcon: const Icon(Icons.grid_view_rounded),
                  label: AppLocalizations.of(context).navHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.stars_rounded),
                  activeIcon: const Icon(Icons.stars_rounded),
                  label: AppLocalizations.of(context).navProgress,
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: AppColors.secondary,
              unselectedItemColor: AppColors.textSecondary.withOpacity(0.5),
              onTap: _onItemTapped,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }
}
