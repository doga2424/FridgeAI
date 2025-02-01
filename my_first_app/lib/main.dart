import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/routes/app_routes.dart';
import 'package:my_first_app/providers/theme_provider.dart';
import 'package:my_first_app/providers/language_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'pages/welcome_screen.dart';
import 'pages/home_page.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_localizations_delegate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _appLocalizationsDelegate = const AppLocalizationsDelegate();

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My First App',
      theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4CAF50),
              secondary: Color(0xFFFF5722),
              background: Color(0xFFFFFFFF),
              surface: Color(0xFFF1F1F1),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onBackground: Color(0xFF212121),
              onSurface: Color(0xFF212121),
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF212121)),
              bodyMedium: TextStyle(color: Color(0xFF757575)),
              bodySmall: TextStyle(color: Color(0xFF757575)),
              displayLarge: TextStyle(color: Color(0xFF212121)),
              displayMedium: TextStyle(color: Color(0xFF212121)),
              displaySmall: TextStyle(color: Color(0xFF212121)),
              headlineLarge: TextStyle(color: Color(0xFF212121)),
              headlineMedium: TextStyle(color: Color(0xFF212121)),
              headlineSmall: TextStyle(color: Color(0xFF212121)),
              titleLarge: TextStyle(color: Color(0xFF212121)),
              titleMedium: TextStyle(color: Color(0xFF212121)),
              titleSmall: TextStyle(color: Color(0xFF212121)),
              labelLarge: TextStyle(color: Color(0xFF212121)),
              labelMedium: TextStyle(color: Color(0xFF212121)),
              labelSmall: TextStyle(color: Color(0xFF212121)),
            ).apply(
              bodyColor: Color(0xFF212121),
              displayColor: Color(0xFF212121),
            ),
            primaryTextTheme: TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF212121)),
              bodyMedium: TextStyle(color: Color(0xFF757575)),
              bodySmall: TextStyle(color: Color(0xFF757575)),
              displayLarge: TextStyle(color: Color(0xFF212121)),
              displayMedium: TextStyle(color: Color(0xFF212121)),
              displaySmall: TextStyle(color: Color(0xFF212121)),
              headlineLarge: TextStyle(color: Color(0xFF212121)),
              headlineMedium: TextStyle(color: Color(0xFF212121)),
              headlineSmall: TextStyle(color: Color(0xFF212121)),
              titleLarge: TextStyle(color: Color(0xFF212121)),
              titleMedium: TextStyle(color: Color(0xFF212121)),
              titleSmall: TextStyle(color: Color(0xFF212121)),
              labelLarge: TextStyle(color: Color(0xFF212121)),
              labelMedium: TextStyle(color: Color(0xFF212121)),
              labelSmall: TextStyle(color: Color(0xFF212121)),
            ).apply(
              bodyColor: Color(0xFF212121),
              displayColor: Color(0xFF212121),
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Color(0xFF757575)),
              hintStyle: TextStyle(color: Color(0xFF757575)),
              floatingLabelStyle: TextStyle(color: Color(0xFF4CAF50)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF757575)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF757575)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
            ),
            cardTheme: CardTheme(
              color: Color(0xFFF1F1F1),
              elevation: 2,
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: TextStyle(fontSize: 18),
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFFF5722),
              foregroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: Color(0xFFFFFFFF),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF4CAF50),
              secondary: Color(0xFFFF5722),
              background: Color(0xFF121212),
              surface: Color(0xFF1E1E1E),
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onBackground: Colors.white,
              onSurface: Colors.white,
            ),
            textTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
              bodySmall: TextStyle(color: Color(0xFFBDBDBD)),
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
              displaySmall: TextStyle(color: Colors.white),
              headlineLarge: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              headlineSmall: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white),
              labelSmall: TextStyle(color: Color(0xFFBDBDBD)),
            ).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            primaryTextTheme: TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
              bodySmall: TextStyle(color: Color(0xFFBDBDBD)),
              displayLarge: TextStyle(color: Colors.white),
              displayMedium: TextStyle(color: Colors.white),
              displaySmall: TextStyle(color: Colors.white),
              headlineLarge: TextStyle(color: Colors.white),
              headlineMedium: TextStyle(color: Colors.white),
              headlineSmall: TextStyle(color: Colors.white),
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              titleSmall: TextStyle(color: Colors.white),
              labelLarge: TextStyle(color: Colors.white),
              labelMedium: TextStyle(color: Colors.white),
              labelSmall: TextStyle(color: Color(0xFFBDBDBD)),
            ).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Color(0xFFBDBDBD)),
              hintStyle: TextStyle(color: Color(0xFFBDBDBD)),
              floatingLabelStyle: TextStyle(color: Color(0xFF4CAF50)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFBDBDBD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFBDBDBD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
            ),
            cardTheme: CardTheme(
              color: Color(0xFF1E1E1E),
              elevation: 2,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                backgroundColor: Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFFFF5722),
              foregroundColor: Colors.white,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
            scaffoldBackgroundColor: Color(0xFF121212),
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.initialRoute,
          routes: {
            '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                // Check if user is logged in
                if (snapshot.hasData) {
                  return HomePage();
                }
                
                // Check if this is first time launch
                final prefs = SharedPreferences.getInstance();
                final hasSeenWelcome = prefs.then((prefs) => prefs.getBool('has_seen_welcome') ?? false);
                
                return FutureBuilder<bool>(
                  future: hasSeenWelcome,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    
                    if (snapshot.hasData && snapshot.data!) {
                      // Returning user, show login page
                      return LoginPage();
                    } else {
                      // First time user, show welcome screen
                      return WelcomeScreen();
                    }
                  },
                );
              },
            ),
            '/welcome': (context) => WelcomeScreen(),
            '/login': (context) => LoginPage(),
            '/register': (context) => SignupPage(),
            '/home': (context) => HomePage(),
          },
          locale: languageProvider.locale,
          supportedLocales: [
            Locale('en', ''), // English
            Locale('tr', ''), // Turkish
          ],
          localizationsDelegates: [
            _appLocalizationsDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}
