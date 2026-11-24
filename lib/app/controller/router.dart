import 'package:flutter/material.dart';
import 'package:apexgarage_sl/app/app.dart';
import 'package:apexgarage_sl/auth/auth.dart';
import 'package:apexgarage_sl/features/apex_garage/presentation/apex_garage_studio_hub.dart';
import 'package:apexgarage_sl/utils/utils.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter();

  final AppStates _appStates = GetIt.instance<AppStates>();

  GoRouter get goRouter => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    refreshListenable: _appStates,
    initialLocation: '${_appStates.homePrefix}/${Pages.home.toPath(isSubRoute: true)}',
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: Pages.splash.toPath(),
        name: Pages.splash.toPathName(),
        pageBuilder: (context, state) => const MaterialPage(child: SplashPage()),
      ),
      GoRoute(
        path: Pages.apexGarage.toPath(),
        name: Pages.apexGarage.toPathName(),
        pageBuilder: (context, state) => const MaterialPage(child: ApexGarageStudioHub()),
      ),
      GoRoute(
        path: Pages.intro.toPath(),
        name: Pages.intro.toPathName(),
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const IntroPage(),
        ),
        routes: [
          GoRoute(
            path: Pages.signIn.toPath(isSubRoute: true),
            name: Pages.signIn.toPathName(),
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SignInPage(),
            ),
            routes: [
              GoRoute(
                path: Pages.forgotPassword.toPath(isSubRoute: true),
                name: Pages.forgotPassword.toPathName(),
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ForgotPassword(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: Pages.signUp.toPath(isSubRoute: true),
            name: Pages.signUp.toPathName(),
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SignUpPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Pages.verify.toPath(),
        name: Pages.verify.toPathName(),
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const CodeVerificationPage(),
        ),
      ),
      GoRoute(
        path: Pages.tutorials.toPath(),
        name: Pages.tutorials.toPathName(),
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const TutorialPage(),
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ShellController(goRouterState: state, child: child),
        routes: [
          GoRoute(
            path: Pages.home.toPath(pathPrefix: _appStates.homePrefix),
            name: Pages.home.toPathName(),
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Home'),
                ),
                body: const Center(
                  child: Text('Home Page'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: Pages.chat.toPath(pathPrefix: _appStates.homePrefix),
            name: Pages.chat.toPathName(),
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Chat'),
                ),
                body: const Center(
                  child: Text('Chat Page'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: Pages.explore.toPath(pathPrefix: _appStates.homePrefix),
            name: Pages.explore.toPathName(),
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Explore'),
                ),
                body: const Center(
                  child: Text('Explore Page'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: Pages.more.toPath(pathPrefix: _appStates.homePrefix),
            name: Pages.more.toPathName(),
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('More'),
                ),
                body: const Center(
                  child: Text('More Page'),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final configuration = _goRouter.routeInformationParser.configuration;

      final splashPath = configuration.namedLocation(Pages.splash.toPathName());
      final apexGaragePath = configuration.namedLocation(Pages.apexGarage.toPathName());

      final isInitialized = _appStates.isInitialized;
      final isGoingToSplash = state.matchedLocation == splashPath;
      final isGoingToApex = state.matchedLocation == apexGaragePath;

      if (!isInitialized && !isGoingToSplash) {
        return splashPath;
      }
      if (isInitialized && !isGoingToApex) {
        return apexGaragePath;
      }
      return null;
    },
  );
}
