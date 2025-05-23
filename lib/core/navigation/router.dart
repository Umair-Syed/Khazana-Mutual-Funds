import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_mutual_funds/core/extensions/color_extensions.dart';
import 'package:khazana_mutual_funds/core/logger/logger.dart';
import 'package:khazana_mutual_funds/core/navigation/routes.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/pages/auth_screen.dart';
import 'package:khazana_mutual_funds/features/charts/presentation/pages/charts_screen.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/pages/fund_details_screen.dart';
import 'package:khazana_mutual_funds/features/home/presentation/pages/home_screen.dart';
import 'package:khazana_mutual_funds/features/wishlist/presentation/pages/wishlist_screen.dart';
import 'package:khazana_mutual_funds/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation:
      sl<SupabaseClient>().auth.currentUser != null
          ? AppRoute.home.path
          : AppRoute.auth.path,
  // Error handler
  errorBuilder: (context, state) {
    logError("Router: Navigation error - ${state.error}");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Navigation error occurred'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.home.path),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  },
  routes: [
    // Bottom navigation shell
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          navigatorKey: shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              name: AppRoute.home.name,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Charts branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.charts.path,
              name: AppRoute.charts.name,
              builder: (context, state) => const ChartsScreen(),
            ),
          ],
        ),
        // Wishlist branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.wishlist.path,
              name: AppRoute.wishlist.name,
              builder: (context, state) => const WishlistScreen(),
            ),
          ],
        ),
      ],
    ),

    // Auth route
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: AppRoute.auth.path,
      name: AppRoute.auth.name,
      builder: (context, state) => const AuthScreen(),
    ),

    // Fund details route
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '${AppRoute.fundDetails.path}/:fundId',
      name: AppRoute.fundDetails.name,
      builder: (context, state) {
        return const FundDetailsScreen();
      },
    ),
  ],
);

// Navigation bar widget
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(color: context.dividerColor, width: 0.5),
            bottom: BorderSide(color: context.dividerColor, width: 0.8),
          ),
        ),
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: [
            BottomNavigationBarItem(
              activeIcon: Icon(
                CupertinoIcons.home,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  CupertinoIcons.home,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                CupertinoIcons.chart_bar,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  CupertinoIcons.chart_bar,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
              label: 'Charts',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                CupertinoIcons.bookmark,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(
                  CupertinoIcons.bookmark,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
              label: 'Wishlist',
            ),
          ],
        ),
      ),
    );
  }
}
