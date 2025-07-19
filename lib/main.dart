import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_wellness_app/theme/app_theme.dart';
import 'firebase_options.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/mood_provider.dart';
import 'providers/journal_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/user_provider.dart';

// Services
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/local_storage_service.dart';

// Screens
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/mood_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/meditation_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/chat/chat_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              // Theme Provider
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) => ThemeProvider(snapshot.data!),
              ),

              // Services
              Provider<AuthService>(create: (_) => AuthService()),
              Provider<DatabaseService>(create: (_) => FirebaseDatabaseService()),
              Provider<LocalStorageService>(
                create: (_) => LocalStorageService(snapshot.data!),
              ),

              // Auth Provider
              ChangeNotifierProxyProvider<AuthService, AuthProvider>(
                create: (context) => AuthProvider(
                  authService: Provider.of<AuthService>(context, listen: false),
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, authService, previous) => AuthProvider(
                  authService: authService,
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                ),
              ),

              // User Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, UserProvider>(
                create: (context) => UserProvider(
                  databaseService: Provider.of<DatabaseService>(context, listen: false),
                  localStorage: Provider.of<LocalStorageService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) => UserProvider(
                  databaseService: databaseService,
                  localStorage: Provider.of<LocalStorageService>(context, listen: false),
                )..updateUserId(auth.user?.uid),
              ),

              // Mood Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, MoodProvider>(
                create: (context) => MoodProvider(
                  Provider.of<DatabaseService>(context, listen: false),
                ),
                update: (context, auth, databaseService, previous) => MoodProvider(databaseService)
                  ..updateUserId(auth.user?.uid),
              ),

              // Journal Provider
              ChangeNotifierProvider<JournalProvider>(
                create: (_) => JournalProvider(),
              ),

              // Chat Provider
              ChangeNotifierProxyProvider2<AuthProvider, DatabaseService, ChatProvider>(
                create: (context) => ChatProvider(Provider.of<DatabaseService>(context, listen: false)),
                update: (context, auth, databaseService, previous) => ChatProvider(databaseService),
              ),
            ],
            child: const MyApp(),
          );
        }
        return const MaterialApp(home: CircularProgressIndicator());
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Student Wellness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/mood': (context) => const MoodScreen(),
        '/journal': (context) => const JournalScreen(),
        '/meditation': (context) =>  MeditationScreen(),
        '/emergency': (context) =>  EmergencyScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/chat': (context) => const ChatListScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return authProvider.isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}