part of 'auth_bloc.dart';

@freezed
sealed class AuthState with _$AuthState{
  const factory AuthState.initial({required AuthStore store}) = Initial;
  const factory AuthState.general({required AuthStore store}) = General;

  const factory AuthState.loginSuccess({required AuthStore store,required String message}) = LoginSuccess;
  const factory AuthState.signUpSuccess({required AuthStore store,required String message}) = SignUpSuccess;
  const factory AuthState.logOutSuccess({required AuthStore store,required String message}) = LogOutSuccess;
  const factory AuthState.authError({required AuthStore store,required String error}) = AuthError;
}