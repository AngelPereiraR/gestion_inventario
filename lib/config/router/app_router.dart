import 'package:go_router/go_router.dart';

import '../../presentation/screens/scrrens.dart';

final appRouter = GoRouter(initialLocation: '/home/0', routes: [
  GoRoute(
    path: '/home/:page',
    name: HomeScreen.name,
    builder: (context, state) {
      final pageIndex = int.parse(state.pathParameters['page'] ?? '0');

      return HomeScreen(pageIndex: pageIndex);
    },
  ),
  GoRoute(
    path: '/',
    redirect: (_, __) => '/home/0',
  ),
]);
