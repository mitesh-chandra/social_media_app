part of 'auth_bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent{
  const factory AuthEvent.setLoginTextEvent({
    String? email,
    String? password,
}) = _SetLoginTextEvent;

  const factory AuthEvent.setSignUpTextEvent({
    String? name,
    String? email,
    DateTime? dob,
    String? gender,
    String? password,
}) = _SetSignUpTextEvent;

  const factory AuthEvent.loginEvent() = _LoginEvent;

  const factory AuthEvent.signUpEvent() = _SignUpEvent;

  const factory AuthEvent.logoutEvent() = _LogoutEvent;
}