import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_tokens.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final IsLoggedInUseCase _isLoggedInUseCase;
  final SignupUseCase _signupUseCase;

  AuthCubit(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
    this._isLoggedInUseCase,
    this._signupUseCase,
  ) : super(const AuthInitial());

  Future<void> login({required String phone, required String password}) async {
    print('🔐 AUTH CUBIT: Starting login with phone: $phone');
    emit(const AuthLoading());

    final result = await _loginUseCase(phone: phone, password: password);

    result.fold(
      (failure) {
        print('🔐 AUTH CUBIT: Login failed - ${failure.message}');
        emit(AuthError(failure.message));
      },
      (tokens) async {
        print('🔐 AUTH CUBIT: Login successful, getting user data...');
        // Get user data after successful login
        final userResult = await _getCurrentUserUseCase();
        userResult.fold(
          (failure) {
            print(
              '🔐 AUTH CUBIT: Failed to get user data - ${failure.message}',
            );
            emit(AuthError(failure.message));
          },
          (user) {
            print(
              '🔐 AUTH CUBIT: User data retrieved - ${user.firstName} (ID: ${user.id})',
            );
            print('🔐 AUTH CUBIT: About to emit AuthAuthenticated state');
            emit(AuthAuthenticated(user: user, tokens: tokens));
            print(
              '🔐 AUTH CUBIT: AuthAuthenticated state emitted successfully',
            );
          },
        );
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());

    final result = await _logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());

    final result = await _isLoggedInUseCase();

    result.fold((failure) => emit(const AuthUnauthenticated()), (
      isLoggedIn,
    ) async {
      if (isLoggedIn) {
        // Get user data
        final userResult = await _getCurrentUserUseCase();
        userResult.fold((failure) => emit(const AuthUnauthenticated()), (user) {
          // Create dummy tokens for authenticated state
          final tokens = AuthTokens(
            accessToken: '',
            refreshToken: '',
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
          );
          emit(AuthAuthenticated(user: user, tokens: tokens));
        });
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signup({
    required String name,
    required String phone,
    required String password,
  }) async {
    emit(const AuthLoading());

    final result = await _signupUseCase(
      name: name,
      phone: phone,
      password: password,
    );

    result.fold((failure) => emit(AuthError(failure.message)), (tokens) async {
      // Get user data after successful signup
      final userResult = await _getCurrentUserUseCase();
      userResult.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthAuthenticated(user: user, tokens: tokens)),
      );
    });
  }

  Future<void> getCurrentUser() async {
    final result = await _getCurrentUserUseCase();

    result.fold((failure) => emit(AuthError(failure.message)), (user) {
      if (state is AuthAuthenticated) {
        final currentState = state as AuthAuthenticated;
        emit(AuthAuthenticated(user: user, tokens: currentState.tokens));
      }
    });
  }
}
