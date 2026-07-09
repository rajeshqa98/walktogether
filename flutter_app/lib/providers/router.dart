// WalkTogether — Router (GoRouter)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers.dart';
import '../screens/screens.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoading = authState.isLoading;
      final gate = authState.gate;

      if (isLoading) return null;
      final currentPath = state.matchedLocation;

      if (!isLoggedIn) {
        if (currentPath == '/login') return null;
        return '/login';
      }

      if (gate != AccountGate.ok) {
        if (currentPath == '/account-status') return null;
        return '/account-status';
      }

      final isNewUser = authState.user?['isNewUser'] == true;
      if (isNewUser && currentPath != '/profile-setup') {
        return '/profile-setup';
      }

      final hasLocation =
          authState.user?['city'] != null || authState.user?['village'] != null;
      if (!isNewUser && !hasLocation && currentPath != '/location') {
        if (currentPath == '/login' || currentPath == '/') {
          return '/location';
        }
      }

      if (isLoggedIn &&
          !isNewUser &&
          (currentPath == '/login' ||
              currentPath == '/profile-setup' ||
              currentPath == '/account-status' ||
              currentPath == '/')) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/account-status',
          builder: (context, state) => const AccountStatusScreen()),
      GoRoute(
          path: '/profile-setup',
          builder: (context, state) => const ProfileSetupScreen()),
      GoRoute(
          path: '/location',
          builder: (context, state) => const LocationPermissionScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: '/walker/:id',
          builder: (context, state) =>
              WalkerDetailScreen(walkerId: state.pathParameters['id']!)),
      GoRoute(
          path: '/requests',
          builder: (context, state) => const RequestsScreen()),
      GoRoute(
          path: '/chat/:requestId',
          builder: (context, state) =>
              ChatScreen(requestId: state.pathParameters['requestId']!)),
      GoRoute(
          path: '/walk-session/:sessionId',
          builder: (context, state) =>
              WalkSessionScreen(sessionId: state.pathParameters['sessionId']!)),
      GoRoute(
          path: '/post-walk/:sessionId',
          builder: (context, state) =>
              PostWalkScreen(sessionId: state.pathParameters['sessionId']!)),
      GoRoute(
          path: '/groups', builder: (context, state) => const GroupsScreen()),
      GoRoute(
          path: '/group/:id',
          builder: (context, state) =>
              GroupWalkDetailScreen(groupWalkId: state.pathParameters['id']!)),
      GoRoute(
          path: '/group-chat/:id',
          builder: (context, state) =>
              GroupChatScreen(groupWalkId: state.pathParameters['id']!)),
      GoRoute(path: '/clubs', builder: (context, state) => const ClubsScreen()),
      GoRoute(
          path: '/club/:id',
          builder: (context, state) =>
              ClubDetailScreen(clubId: state.pathParameters['id']!)),
      GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen()),
      GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: '/privacy-requests',
          builder: (context, state) => const PrivacyRequestsScreen()),
      GoRoute(
          path: '/appeals', builder: (context, state) => const AppealsScreen()),
      GoRoute(
          path: '/feedback',
          builder: (context, state) => const FeedbackScreen()),
    ],
  );
});
