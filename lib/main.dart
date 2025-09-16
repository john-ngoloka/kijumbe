import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/database/app_database.dart';
import 'features/authentication/presentation/cubit/auth_cubit.dart';
import 'features/authentication/presentation/screens/login_screen.dart';
import 'features/authentication/presentation/screens/signup_screen.dart';
import 'features/authentication/presentation/screens/group_selection_screen.dart';
import 'features/authentication/presentation/screens/account_created_screen.dart';
import 'features/group/presentation/screens/admin_dashboard_screen.dart';
import 'features/group/presentation/screens/member_dashboard_screen.dart';
import 'features/group/presentation/screens/add_member_screen.dart';
import 'features/group/presentation/screens/group_detail_screen.dart';
import 'features/group/presentation/cubit/group_member_cubit.dart';
import 'features/authentication/domain/entities/user.dart';
import 'features/authentication/presentation/utils/navigation_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize database
  try {
    await AppDatabase.instance;
  } catch (e) {
    print('Database initialization error: $e');
  }

  runApp(const KijumbeApp());
}

class KijumbeApp extends StatelessWidget {
  const KijumbeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp(
        title: 'Kijumbe',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            print('🏠 MAIN: ===== BlocBuilder CALLED =====');
            print(
              '🏠 MAIN: BlocBuilder state changed to: ${state.runtimeType}',
            );
            if (state is AuthLoading) {
              print('🏠 MAIN: Showing loading screen');
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              print(
                '🏠 MAIN: User is authenticated - calling NavigationHelper',
              );
              print(
                '🏠 MAIN: User ID: ${state.user.id}, Name: ${state.user.firstName}',
              );
              // SIMPLE TEST: Just navigate directly to member dashboard
              WidgetsBinding.instance.addPostFrameCallback((_) {
                print(
                  '🏠 MAIN: PostFrameCallback executing SIMPLE navigation test',
                );
                Navigator.of(context).pushReplacementNamed(
                  '/member-dashboard',
                  arguments: state.user,
                );
              });
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else {
              print('🏠 MAIN: Showing login page');
              return const LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/account-created': (context) => const AccountCreatedScreen(),
          '/group-selection': (context) => const GroupSelectionScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
          '/add-member': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
            return BlocProvider(
              create: (context) => getIt<GroupMemberCubit>(),
              child: AddMemberScreen(
                groupId: args?['groupId'] ?? '',
                groupName: args?['groupName'] ?? '',
              ),
            );
          },
          '/group-detail': (context) {
            final args =
                ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
            return GroupDetailScreen(
              groupId: args?['groupId'] ?? '',
              groupName: args?['groupName'] ?? '',
              isAdmin: args?['isAdmin'] ?? false,
            );
          },
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/member-dashboard') {
            final user = settings.arguments as User?;
            return MaterialPageRoute(
              builder: (context) => MemberDashboardScreen(user: user),
            );
          }
          return null;
        },
      ),
    );
  }
}
