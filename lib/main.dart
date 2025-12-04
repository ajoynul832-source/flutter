import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'services/auth_service.dart';
import 'services/file_service.dart';      // <-- Added
import 'screens/home_screen.dart';
import 'screens/files_screen.dart';
import 'screens/tools_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FileService()), // <-- Added
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Versatile Toolkit',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,

      // LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F4F5), // zinc-100
        primaryColor: const Color(0xFF7E22CE), // purple-700
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7E22CE)),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),

      // DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF09090B), // zinc-950
        primaryColor: const Color(0xFFA855F7), // purple-500
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA855F7),
          brightness: Brightness.dark,
        ),
        textTheme:
            GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),

      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FilesScreen(),
    const ToolsScreen(),
    const ScannerScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
              icon: Icon(LucideIcons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(LucideIcons.folder), label: 'Files'),
          NavigationDestination(
              icon: Icon(LucideIcons.layoutGrid), label: 'Tools'),
          NavigationDestination(
              icon: Icon(LucideIcons.scanLine), label: 'Scanner'),
          NavigationDestination(
              icon: Icon(LucideIcons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}