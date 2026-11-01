import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:vakif_atlas/core/usecase/usecase.dart';
import 'package:vakif_atlas/features/auth/domain/entities/auth_session_event.dart';
import 'package:vakif_atlas/features/auth/domain/entities/user_entity.dart';
import 'package:vakif_atlas/features/auth/domain/usecases/auth_usecases.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// Uygulama genelindeki oturum durumu (guest / citizen).
///
/// Router'ın `AuthGuard`'ı bu durumu dinleyerek korumalı rotalara erişimi
/// yönetir.
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._restoreSession,
    this._logout,
    WatchAuthSessionUseCase watchSession,
  ) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted, transformer: droppable());
    on<AuthLogoutRequested>(_onLogoutRequested, transformer: droppable());
    on<AuthSessionChanged>(_onSessionChanged);

    _sessionSubscription = watchSession(const NoParams())
        .listen((event) => add(AuthEvent.sessionChanged(event)));
  }

  final RestoreSessionUseCase _restoreSession;
  final LogoutUseCase _logout;
  late final StreamSubscription<AuthSessionEvent> _sessionSubscription;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _restoreSession(const NoParams());
    emit(
      result.fold(
        (_) => const AuthState.guest(),
        (user) => user == null
            ? const AuthState.guest()
            : AuthState.authenticated(user),
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(const AuthState.guest());
  }

  void _onSessionChanged(AuthSessionChanged event, Emitter<AuthState> emit) {
    switch (event.event) {
      case SignedIn(:final user):
        emit(AuthState.authenticated(user));
      case SignedOut() || AccountDeleted():
        emit(const AuthState.guest());
      case SessionExpired():
        if (state is AuthAuthenticated) {
          emit(const AuthState.guest(sessionExpired: true));
        }
    }
  }

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    return super.close();
  }
}
