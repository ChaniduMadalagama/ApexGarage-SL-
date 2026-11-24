import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:apexgarage_sl/app/app.dart';
import 'package:apexgarage_sl/utils/utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
    super.initState();
  }

  /// Initializes the application by delaying for 2 seconds
  /// and setting the `isInitialized` property of `AppStates` to true.
  Future<void> init() async {
    FlutterNativeSplash.remove();
    await Future.delayed(const Duration(seconds: 2), () {});
    await GetIt.instance<AppStates>().onAppStart();
    GetIt.instance<AppStates>().isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: AppLogo(aspectRatio: 1.5),
        ),
      ),
    );
  }
}
