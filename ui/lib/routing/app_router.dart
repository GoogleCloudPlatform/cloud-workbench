import 'package:cloudprovision/modules/catalog/catalog_screen.dart';
import 'package:cloudprovision/modules/example_screen/example.dart';
import 'package:cloudprovision/modules/home_page/home_screen.dart';
import 'package:cloudprovision/modules/my_services/my_services_screen.dart';
import 'package:cloudprovision/modules/my_services/service_detail.dart';

import 'package:cloudprovision/modules/settings/settings_screen.dart';
import 'package:cloudprovision/modules/workstations/my_workstations_screen.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../modules/auth/repositories/auth_provider.dart';
import '../modules/auth/sign_in_screen.dart';

part 'app_router.g.dart';

final _key = GlobalKey<NavigatorState>();

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authFirebaseState = ref.watch(authProvider);
  final authState = ref.watch(googleAuthProvider);

  return GoRouter(
    navigatorKey: _key,
    initialLocation: '/login',
    redirect: (context, state) async {
      if (authState.valueOrNull == null)
        return "/login";

      if (authState.isLoading || authState.hasError) return null;

      final isAuth = authState.valueOrNull != null;

      final isLoggingIn = state.location == '/login';
      if (isLoggingIn) return isAuth ? '/home' : null;

      return isAuth ? null : '/login';
    },
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/example',
        name: 'example',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: ExampleScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/services',
        name: 'services',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: MyServicesScreen(),
        ),
      ),
      GoRoute(
          path: '/service/:serviceDocId',
          name: 'service',
          pageBuilder: (context, state) {
            final serviceID = state.params['serviceDocId']!;
            return buildPageWithDefaultTransition<void>(
              context: context,
              state: state,
              child: ServiceDetail(serviceID),
            );
          }),
      GoRoute(
        path: '/catalog',
        name: 'catalog',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: CatalogScreen(),
        ),
      ),
      GoRoute(
        path: '/workstations',
        name: 'workstations',
        pageBuilder: (context, state) => buildPageWithDefaultTransition<void>(
          context: context,
          state: state,
          child: MyWorkstationsScreen(),
        ),
      ),
    ],
  );
}
