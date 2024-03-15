import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestion_inventario/config/config.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/providers/providers.dart';
import '../../presentation/screens/screens.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/home/0',
    refreshListenable: goRouterNotifier,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),
      GoRoute(
        path: '/home/:page',
        name: HomeScreen.name,
        builder: (context, state) {
          final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

          return HomeScreen(pageIndex: pageIndex);
        },
      ),
      GoRoute(
        path: '/auth/:page',
        name: AuthScreen.name,
        builder: (context, state) {
          final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

          return AuthScreen(pageIndex: pageIndex);
        },
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/auth/0' || isGoingTo == '/auth/1') return null;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/auth/0' ||
            isGoingTo == '/auth/1' ||
            isGoingTo == '/splash') {
          return '/home/0';
        }
      }

      return null;
    },
  );
});
