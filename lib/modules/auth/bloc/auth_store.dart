part of 'auth_bloc.dart';

@freezed
sealed class AuthStore with _$AuthStore{
 const factory AuthStore({
  @Default(false) bool isLoading,
  @Default('') String loginEmail,
  @Default('') String loginPassword,
  @Default('') String signUpName,
  @Default('') String signUpEmail,
  @Default('') String signUpPassword,
  @Default('') String signUpGender,
  @Default(null) DateTime? signUpDob,
})= _AuthStore;
}