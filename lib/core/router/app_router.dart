import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:architect_nexus/features/auth/presentation/screens/login_screen.dart';
import 'package:architect_nexus/features/home/presentation/screens/home_screen.dart';
import 'package:architect_nexus/features/learning/presentation/screens/module_viewer_screen.dart';
import 'package:architect_nexus/features/profile/presentation/screens/profile_screen.dart';

/// App Router Provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    routes: [
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Learning Module Route
      GoRoute(
        path: '/module/:id',
        name: 'module',
        builder: (context, state) {
          final moduleId = state.pathParameters['id']!;
          return ModuleViewerScreen(moduleId: moduleId);
        },
      ),
      
      // Profile Route
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});
