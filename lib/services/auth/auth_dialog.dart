import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'sign_in_screen.dart';
import 'sign_up_screen.dart';
import 'profile_screen.dart';
import 'forgot_password_screen.dart';
import 'choice_screen.dart';

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  // Views: 'choice', 'signIn', 'signUp', 'forgotPassword', 'profile'
  String _currentView = 'choice';

  @override
  void initState() {
    super.initState();
    // If already logged in, show profile immediately
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user != null) {
      _currentView = 'profile';
    }
  }

  void _changeView(String view) {
    setState(() => _currentView = view);
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state to auto-switch to profile on success
    final authService = Provider.of<AuthService>(context);

    // If user just logged in and we are not on profile, switch to profile
    if (authService.currentUser != null && _currentView != 'profile') {
      _currentView = 'profile';
    }

    Widget content;
    switch (_currentView) {
      case 'signIn':
        content = SignInScreen(onViewChange: _changeView);
        break;
      case 'signUp':
        content = SignUpScreen(onViewChange: _changeView);
        break;
      case 'forgotPassword':
        content = ForgotPasswordScreen(onViewChange: _changeView);
        break;
      case 'profile':
        content = ProfileScreen(onViewChange: _changeView);
        break;
      case 'choice':
      default:
        content = ChoiceScreen(onViewChange: _changeView);
        break;
    }

    // This makes it look like the Dialog in your screenshot
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 550),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: content,
        ),
      ),
    );
  }
}