import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../widgets/universal_row.dart';
import '../services/auth_service.dart';      // <-- added
import 'auth/auth_dialog.dart';             // <-- added

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                _buildGroupHeader('Account'),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      UniversalRow(
                        icon: LucideIcons.user,
                        // 👇 dynamic label based on auth state
                        label: Provider.of<AuthService>(context)
                                .currentUser
                                ?.name ??
                            'Sign In / Register',
                        hasArrow: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => const AuthDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                _buildGroupHeader('Preferences'),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF18181B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const UniversalRow(
                        icon: LucideIcons.cloud,
                        label: 'Cloud Drive',
                        hasArrow: true,
                      ),
                      const Divider(height: 1, indent: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.moon, size: 22),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dark Mode',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    isDark ? 'On' : 'Off',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isDark,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (value) =>
                                  themeProvider.toggleTheme(value),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, indent: 50),
                      const UniversalRow(
                        icon: LucideIcons.globe,
                        label: 'Language',
                        badge: 'English',
                        hasArrow: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}