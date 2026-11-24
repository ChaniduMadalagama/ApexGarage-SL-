import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:apexgarage_sl/app/app.dart';
import 'package:apexgarage_sl/auth/auth.dart';
import 'package:apexgarage_sl/core/theme/app_theme.dart';
import 'package:apexgarage_sl/core/state/apex_app_state.dart';
import 'package:apexgarage_sl/features/main_shell.dart';
import 'package:apexgarage_sl/utils/utils.dart';

class StarterApp extends StatefulWidget {
  const StarterApp({super.key});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  final AppStates _appStates = GetIt.instance<AppStates>();
  final ThemeServiceProvider _themeServiceProvider = GetIt.instance<ThemeServiceProvider>();
  final ApexAppState _apexAppState = ApexAppState();

  late StreamSubscription<BoxEvent> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    _authStateSubscription = Hive.box<String>(GetIt.instance<AppSettings>().sessionSecretKey).watch().listen(onAuthStateChanged);

    _themeServiceProvider.addListener(() {
      if (_themeServiceProvider.themeMode == ThemeMode.dark) {
        ThemeServiceProvider.setSystemUIOverlayStyle(isDark: true);
      } else {
        ThemeServiceProvider.setSystemUIOverlayStyle();
      }
    });
  }

  void onAuthStateChanged(BoxEvent event) {
    log('onAuthStateChanged: ${event.value}', name: 'StarterAppState');
    if (event.value != null && event.value is String) {
      _appStates.currentSession = Session.fromJson(jsonDecode(event.value as String) as Map<String, dynamic>);
    } else {
      _appStates
        ..currentSession = null
        ..isInitialized = false;
    }
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    _apexAppState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _apexAppState),
        Provider(create: (_) => GetIt.instance<AppSettings>()),
        ChangeNotifierProvider(create: (_) => GetIt.instance<ThemeServiceProvider>()),
      ],
      child: MaterialApp(
        title: 'ApexGarage SL',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        home: MainShell(appState: _apexAppState),
        builder: (context, child) => OverlayUtility(child: child),
      ),
    );
  }
}
