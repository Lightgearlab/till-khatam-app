import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tillkhatam/core/app_theme.dart';
import 'package:tillkhatam/src/business_logic/provider/quran_provider.dart';
import 'package:tillkhatam/src/business_logic/provider/theme_provider.dart';
import 'package:tillkhatam/src/data/repository/read_repo.dart';
import 'package:tillkhatam/src/data/repository/user_repo.dart';
import 'package:tillkhatam/src/presentation/screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app_route.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()..loadTheme()),
        Provider<UserRepo>(create: (context) => UserRepo()),
        Provider<ReadRepo>(create: (context) => ReadRepo()),
        ChangeNotifierProvider<QuranProvider>(
          create: (context) => QuranProvider(
            context.read<UserRepo>(),
            context.read<ReadRepo>(),
          )..init(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoute.HOME,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'),
            ],
            routes: {
              AppRoute.HOME: (context) => const MainScreen(),
            },
            // Enable horizontal scroll on flutter web
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              },
            ),
            theme: themeProvider.theme == 'hafiz'
                ? AppTheme.hafizTheme
                : AppTheme.sakinahTheme,
          );
        },
      ),
    );
  }
}
