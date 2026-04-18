import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../theme/app_theme.dart';

bool _initialized = false;

Future<void> signInWithGoogle(BuildContext context) async {
  // try {
    // Initialize once
    if (!_initialized) {
      await GoogleSignIn.instance.initialize();
      _initialized = true;
    }

    final account = await GoogleSignIn.instance.authenticate();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Signed In',
            style: TextStyle(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
          content: Row(
            children: [
              if (account.photoUrl != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(account.photoUrl!),
                  radius: 22,
                ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.displayName ?? '',
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      account.email,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK',
                  style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }
  // } catch (e) {
  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Sign in failed: $e'),
  //         backgroundColor: AppColors.accent,
  //       ),
  //     );
  //   }
  // }
}
