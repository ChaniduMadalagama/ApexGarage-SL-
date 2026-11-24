import 'package:flutter/material.dart';
import 'package:apexgarage_sl/app/app.dart';

import 'package:apexgarage_sl/utils/utils.dart';

class ShellController extends StatelessWidget {
  const ShellController({
    required this.child, required this.goRouterState, super.key,
  });

  final Widget child;
  final GoRouterState goRouterState;

  int get currentIndex {
    final currentLocation = goRouterState.matchedLocation;
    final prefix = GetIt.I<AppStates>().homePrefix;
    if (currentLocation.startsWith(Pages.home.toPath(pathPrefix: prefix))) {
      return 0;
    } else if (currentLocation.startsWith(Pages.chat.toPath(pathPrefix: prefix))) {
      return 1;
    } else if (currentLocation.startsWith(Pages.explore.toPath(pathPrefix: prefix))) {
      return 2;
    } else if (currentLocation.startsWith(Pages.more.toPath(pathPrefix: prefix))) {
      return 3;
    } else {
      return 0;
    }
  }

  void onNavigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Pages.home.go(context);
      case 1:
        Pages.chat.go(context);
      case 2:
        Pages.explore.go(context);
      case 3:
        Pages.more.go(context);
      default:
        Pages.home.go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onNavigate(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.message),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.compass),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.ellipsisVertical),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
