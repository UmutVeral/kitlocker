import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/locker/screens/locker_entry_detail_screen.dart';
import '../../features/locker/screens/locker_entry_form_screen.dart';
import '../../features/locker/screens/locker_screen.dart';
import '../../features/splash/screens/splash_screen.dart';
import 'app_routes.dart';
import 'router_notifier.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = RouterNotifier(ref);
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.auth, builder: (_, _) => const AuthScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.locker,
        builder: (_, _) => const LockerScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, _) => const LockerEntryFormScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (_, state) => LockerEntryDetailScreen(
              id: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
});
