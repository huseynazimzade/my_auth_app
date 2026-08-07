import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Yüklənmə vaxtı yönləndirmə etmirik
      if (authState.isLoading) return null;

      final user = authState.value;
      final isAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // İstifadəçi daxil olmayıbsa və auth səhifəsində deyilsə -> /login-ə yönləndir
      if (user == null && !isAuthPage) {
        return '/login';
      }

      // İstifadəçi daxil olubsa və auth səhifəsindədirsə -> Ana səhifəyə (/) yönləndir
      if (user != null && isAuthPage) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
  );
});