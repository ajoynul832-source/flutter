import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final Function(String) onViewChange;
  const ProfileScreen({super.key, required this.onViewChange});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    if (user == null) {
      // Safety fallback
      Future.microtask(() => onViewChange('choice'));
      return const SizedBox(); 
    }

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(LucideIcons.arrowLeft),
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              onPressed: () => Navigator.of(context).pop(), // Close dialog
            ),
            const Text("Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(),
        const Spacer(),
        CircleAvatar(
          radius: 48,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            user.name[0].toUpperCase(),
            style: TextStyle(fontSize: 36, color: Theme.of(context).primaryColor),
          ),
        ),
        const SizedBox(height: 16),
        Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(user.email, style: TextStyle(color: Theme.of(context).hintColor)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            "Signed in with ${user.provider == 'google' ? 'Google' : 'Email'}",
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
        ),
        const Spacer(),
        const Divider(),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(onPressed: (){}, child: const Text("Manage Account")),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              authService.signOut();
              onViewChange('choice');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text("Sign Out"),
          ),
        ),
      ],
    );
  }
}