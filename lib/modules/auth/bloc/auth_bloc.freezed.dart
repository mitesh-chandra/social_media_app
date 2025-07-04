
part of 'auth_bloc.dart';
T _$identity<T>(T value) => value;
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


class _SetLoginTextEvent implements AuthEvent {
  const _SetLoginTextEvent({this.email, this.password});
  

 final  String? email;
 final  String? password;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetLoginTextEventCopyWith<_SetLoginTextEvent> get copyWith => __$SetLoginTextEventCopyWithImpl<_SetLoginTextEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetLoginTextEvent&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.setLoginTextEvent(email: $email, password: $password)';
}


}
abstract mixin class _$SetLoginTextEventCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SetLoginTextEventCopyWith(_SetLoginTextEvent value, $Res Function(_SetLoginTextEvent) _then) = __$SetLoginTextEventCopyWithImpl;
@useResult
$Res call({
 String? email, String? password
});




}
class __$SetLoginTextEventCopyWithImpl<$Res>
    implements _$SetLoginTextEventCopyWith<$Res> {
  __$SetLoginTextEventCopyWithImpl(this._self, this._then);

  final _SetLoginTextEvent _self;
  final $Res Function(_SetLoginTextEvent) _then;
@pragma('vm:prefer-inline') $Res call({Object? email = freezed,Object? password = freezed,}) {
  return _then(_SetLoginTextEvent(
email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


class _SetSignUpTextEvent implements AuthEvent {
  const _SetSignUpTextEvent({this.name, this.email, this.dob, this.gender, this.password, this.profilePath});
  

 final  String? name;
 final  String? email;
 final  DateTime? dob;
 final  String? gender;
 final  String? password;
 final  String? profilePath;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetSignUpTextEventCopyWith<_SetSignUpTextEvent> get copyWith => __$SetSignUpTextEventCopyWithImpl<_SetSignUpTextEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetSignUpTextEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.password, password) || other.password == password)&&(identical(other.profilePath, profilePath) || other.profilePath == profilePath));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,dob,gender,password,profilePath);

@override
String toString() {
  return 'AuthEvent.setSignUpTextEvent(name: $name, email: $email, dob: $dob, gender: $gender, password: $password, profilePath: $profilePath)';
}


}
abstract mixin class _$SetSignUpTextEventCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SetSignUpTextEventCopyWith(_SetSignUpTextEvent value, $Res Function(_SetSignUpTextEvent) _then) = __$SetSignUpTextEventCopyWithImpl;
@useResult
$Res call({
 String? name, String? email, DateTime? dob, String? gender, String? password, String? profilePath
});




}
class __$SetSignUpTextEventCopyWithImpl<$Res>
    implements _$SetSignUpTextEventCopyWith<$Res> {
  __$SetSignUpTextEventCopyWithImpl(this._self, this._then);

  final _SetSignUpTextEvent _self;
  final $Res Function(_SetSignUpTextEvent) _then;
@pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? email = freezed,Object? dob = freezed,Object? gender = freezed,Object? password = freezed,Object? profilePath = freezed,}) {
  return _then(_SetSignUpTextEvent(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,profilePath: freezed == profilePath ? _self.profilePath : profilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


class _UpdateUserProfileEvent implements AuthEvent {
  const _UpdateUserProfileEvent(this.imagePath);
  

 final  String? imagePath;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateUserProfileEventCopyWith<_UpdateUserProfileEvent> get copyWith => __$UpdateUserProfileEventCopyWithImpl<_UpdateUserProfileEvent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateUserProfileEvent&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,imagePath);

@override
String toString() {
  return 'AuthEvent.updateUserProfileEvent(imagePath: $imagePath)';
}


}
abstract mixin class _$UpdateUserProfileEventCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$UpdateUserProfileEventCopyWith(_UpdateUserProfileEvent value, $Res Function(_UpdateUserProfileEvent) _then) = __$UpdateUserProfileEventCopyWithImpl;
@useResult
$Res call({
 String? imagePath
});




}
class __$UpdateUserProfileEventCopyWithImpl<$Res>
    implements _$UpdateUserProfileEventCopyWith<$Res> {
  __$UpdateUserProfileEventCopyWithImpl(this._self, this._then);

  final _UpdateUserProfileEvent _self;
  final $Res Function(_UpdateUserProfileEvent) _then;
@pragma('vm:prefer-inline') $Res call({Object? imagePath = freezed,}) {
  return _then(_UpdateUserProfileEvent(
freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


class _LoginEvent implements AuthEvent {
  const _LoginEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.loginEvent()';
}


}


class _SignUpEvent implements AuthEvent {
  const _SignUpEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signUpEvent()';
}


}


class _LogoutEvent implements AuthEvent {
  const _LogoutEvent();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LogoutEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logoutEvent()';
}


}
mixin _$AuthState {

 AuthStore get store;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'AuthState(store: $store)';
}


}
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 AuthStore store
});


$AuthStoreCopyWith<$Res> get store;

}
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;
@pragma('vm:prefer-inline') @override $Res call({Object? store = null,}) {
  return _then(_self.copyWith(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class Initial implements AuthState {
  const Initial({required this.store});
  

@override final  AuthStore store;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InitialCopyWith<Initial> get copyWith => _$InitialCopyWithImpl<Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Initial&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'AuthState.initial(store: $store)';
}


}
abstract mixin class $InitialCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $InitialCopyWith(Initial value, $Res Function(Initial) _then) = _$InitialCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$InitialCopyWithImpl<$Res>
    implements $InitialCopyWith<$Res> {
  _$InitialCopyWithImpl(this._self, this._then);

  final Initial _self;
  final $Res Function(Initial) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,}) {
  return _then(Initial(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class General implements AuthState {
  const General({required this.store});
  

@override final  AuthStore store;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneralCopyWith<General> get copyWith => _$GeneralCopyWithImpl<General>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is General&&(identical(other.store, store) || other.store == store));
}


@override
int get hashCode => Object.hash(runtimeType,store);

@override
String toString() {
  return 'AuthState.general(store: $store)';
}


}
abstract mixin class $GeneralCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $GeneralCopyWith(General value, $Res Function(General) _then) = _$GeneralCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$GeneralCopyWithImpl<$Res>
    implements $GeneralCopyWith<$Res> {
  _$GeneralCopyWithImpl(this._self, this._then);

  final General _self;
  final $Res Function(General) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,}) {
  return _then(General(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class PofilePicUpdated implements AuthState {
  const PofilePicUpdated({required this.store, required this.message});
  

@override final  AuthStore store;
 final  String message;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PofilePicUpdatedCopyWith<PofilePicUpdated> get copyWith => _$PofilePicUpdatedCopyWithImpl<PofilePicUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PofilePicUpdated&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'AuthState.profilePicUpdated(store: $store, message: $message)';
}


}
abstract mixin class $PofilePicUpdatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $PofilePicUpdatedCopyWith(PofilePicUpdated value, $Res Function(PofilePicUpdated) _then) = _$PofilePicUpdatedCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store, String message
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$PofilePicUpdatedCopyWithImpl<$Res>
    implements $PofilePicUpdatedCopyWith<$Res> {
  _$PofilePicUpdatedCopyWithImpl(this._self, this._then);

  final PofilePicUpdated _self;
  final $Res Function(PofilePicUpdated) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(PofilePicUpdated(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class LoginSuccess implements AuthState {
  const LoginSuccess({required this.store, required this.message});
  

@override final  AuthStore store;
 final  String message;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginSuccessCopyWith<LoginSuccess> get copyWith => _$LoginSuccessCopyWithImpl<LoginSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginSuccess&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'AuthState.loginSuccess(store: $store, message: $message)';
}


}
abstract mixin class $LoginSuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $LoginSuccessCopyWith(LoginSuccess value, $Res Function(LoginSuccess) _then) = _$LoginSuccessCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store, String message
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$LoginSuccessCopyWithImpl<$Res>
    implements $LoginSuccessCopyWith<$Res> {
  _$LoginSuccessCopyWithImpl(this._self, this._then);

  final LoginSuccess _self;
  final $Res Function(LoginSuccess) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(LoginSuccess(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class SignUpSuccess implements AuthState {
  const SignUpSuccess({required this.store, required this.message});
  

@override final  AuthStore store;
 final  String message;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpSuccessCopyWith<SignUpSuccess> get copyWith => _$SignUpSuccessCopyWithImpl<SignUpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpSuccess&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'AuthState.signUpSuccess(store: $store, message: $message)';
}


}
abstract mixin class $SignUpSuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $SignUpSuccessCopyWith(SignUpSuccess value, $Res Function(SignUpSuccess) _then) = _$SignUpSuccessCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store, String message
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$SignUpSuccessCopyWithImpl<$Res>
    implements $SignUpSuccessCopyWith<$Res> {
  _$SignUpSuccessCopyWithImpl(this._self, this._then);

  final SignUpSuccess _self;
  final $Res Function(SignUpSuccess) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(SignUpSuccess(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class LogOutSuccess implements AuthState {
  const LogOutSuccess({required this.store, required this.message});
  

@override final  AuthStore store;
 final  String message;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LogOutSuccessCopyWith<LogOutSuccess> get copyWith => _$LogOutSuccessCopyWithImpl<LogOutSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LogOutSuccess&&(identical(other.store, store) || other.store == store)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,store,message);

@override
String toString() {
  return 'AuthState.logOutSuccess(store: $store, message: $message)';
}


}
abstract mixin class $LogOutSuccessCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $LogOutSuccessCopyWith(LogOutSuccess value, $Res Function(LogOutSuccess) _then) = _$LogOutSuccessCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store, String message
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$LogOutSuccessCopyWithImpl<$Res>
    implements $LogOutSuccessCopyWith<$Res> {
  _$LogOutSuccessCopyWithImpl(this._self, this._then);

  final LogOutSuccess _self;
  final $Res Function(LogOutSuccess) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? message = null,}) {
  return _then(LogOutSuccess(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}


class AuthError implements AuthState {
  const AuthError({required this.store, required this.error});
  

@override final  AuthStore store;
 final  String error;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthErrorCopyWith<AuthError> get copyWith => _$AuthErrorCopyWithImpl<AuthError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthError&&(identical(other.store, store) || other.store == store)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,store,error);

@override
String toString() {
  return 'AuthState.authError(store: $store, error: $error)';
}


}
abstract mixin class $AuthErrorCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthErrorCopyWith(AuthError value, $Res Function(AuthError) _then) = _$AuthErrorCopyWithImpl;
@override @useResult
$Res call({
 AuthStore store, String error
});


@override $AuthStoreCopyWith<$Res> get store;

}
class _$AuthErrorCopyWithImpl<$Res>
    implements $AuthErrorCopyWith<$Res> {
  _$AuthErrorCopyWithImpl(this._self, this._then);

  final AuthError _self;
  final $Res Function(AuthError) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? store = null,Object? error = null,}) {
  return _then(AuthError(
store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as AuthStore,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
@override
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<$Res> get store {
  
  return $AuthStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}
}
mixin _$AuthStore {

 bool get isLoading; String get loginEmail; String get loginPassword; String get signUpName; String get signUpEmail; String get signUpPassword; String get signUpGender; DateTime? get signUpDob; String? get signUpProfilePath;
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStoreCopyWith<AuthStore> get copyWith => _$AuthStoreCopyWithImpl<AuthStore>(this as AuthStore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthStore&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loginEmail, loginEmail) || other.loginEmail == loginEmail)&&(identical(other.loginPassword, loginPassword) || other.loginPassword == loginPassword)&&(identical(other.signUpName, signUpName) || other.signUpName == signUpName)&&(identical(other.signUpEmail, signUpEmail) || other.signUpEmail == signUpEmail)&&(identical(other.signUpPassword, signUpPassword) || other.signUpPassword == signUpPassword)&&(identical(other.signUpGender, signUpGender) || other.signUpGender == signUpGender)&&(identical(other.signUpDob, signUpDob) || other.signUpDob == signUpDob)&&(identical(other.signUpProfilePath, signUpProfilePath) || other.signUpProfilePath == signUpProfilePath));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,loginEmail,loginPassword,signUpName,signUpEmail,signUpPassword,signUpGender,signUpDob,signUpProfilePath);

@override
String toString() {
  return 'AuthStore(isLoading: $isLoading, loginEmail: $loginEmail, loginPassword: $loginPassword, signUpName: $signUpName, signUpEmail: $signUpEmail, signUpPassword: $signUpPassword, signUpGender: $signUpGender, signUpDob: $signUpDob, signUpProfilePath: $signUpProfilePath)';
}


}
abstract mixin class $AuthStoreCopyWith<$Res>  {
  factory $AuthStoreCopyWith(AuthStore value, $Res Function(AuthStore) _then) = _$AuthStoreCopyWithImpl;
@useResult
$Res call({
 bool isLoading, String loginEmail, String loginPassword, String signUpName, String signUpEmail, String signUpPassword, String signUpGender, DateTime? signUpDob, String? signUpProfilePath
});




}
class _$AuthStoreCopyWithImpl<$Res>
    implements $AuthStoreCopyWith<$Res> {
  _$AuthStoreCopyWithImpl(this._self, this._then);

  final AuthStore _self;
  final $Res Function(AuthStore) _then;
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loginEmail = null,Object? loginPassword = null,Object? signUpName = null,Object? signUpEmail = null,Object? signUpPassword = null,Object? signUpGender = null,Object? signUpDob = freezed,Object? signUpProfilePath = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loginEmail: null == loginEmail ? _self.loginEmail : loginEmail // ignore: cast_nullable_to_non_nullable
as String,loginPassword: null == loginPassword ? _self.loginPassword : loginPassword // ignore: cast_nullable_to_non_nullable
as String,signUpName: null == signUpName ? _self.signUpName : signUpName // ignore: cast_nullable_to_non_nullable
as String,signUpEmail: null == signUpEmail ? _self.signUpEmail : signUpEmail // ignore: cast_nullable_to_non_nullable
as String,signUpPassword: null == signUpPassword ? _self.signUpPassword : signUpPassword // ignore: cast_nullable_to_non_nullable
as String,signUpGender: null == signUpGender ? _self.signUpGender : signUpGender // ignore: cast_nullable_to_non_nullable
as String,signUpDob: freezed == signUpDob ? _self.signUpDob : signUpDob // ignore: cast_nullable_to_non_nullable
as DateTime?,signUpProfilePath: freezed == signUpProfilePath ? _self.signUpProfilePath : signUpProfilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


class _AuthStore implements AuthStore {
  const _AuthStore({this.isLoading = false, this.loginEmail = '', this.loginPassword = '', this.signUpName = '', this.signUpEmail = '', this.signUpPassword = '', this.signUpGender = '', this.signUpDob = null, this.signUpProfilePath = null});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  String loginEmail;
@override@JsonKey() final  String loginPassword;
@override@JsonKey() final  String signUpName;
@override@JsonKey() final  String signUpEmail;
@override@JsonKey() final  String signUpPassword;
@override@JsonKey() final  String signUpGender;
@override@JsonKey() final  DateTime? signUpDob;
@override@JsonKey() final  String? signUpProfilePath;
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStoreCopyWith<_AuthStore> get copyWith => __$AuthStoreCopyWithImpl<_AuthStore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthStore&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loginEmail, loginEmail) || other.loginEmail == loginEmail)&&(identical(other.loginPassword, loginPassword) || other.loginPassword == loginPassword)&&(identical(other.signUpName, signUpName) || other.signUpName == signUpName)&&(identical(other.signUpEmail, signUpEmail) || other.signUpEmail == signUpEmail)&&(identical(other.signUpPassword, signUpPassword) || other.signUpPassword == signUpPassword)&&(identical(other.signUpGender, signUpGender) || other.signUpGender == signUpGender)&&(identical(other.signUpDob, signUpDob) || other.signUpDob == signUpDob)&&(identical(other.signUpProfilePath, signUpProfilePath) || other.signUpProfilePath == signUpProfilePath));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,loginEmail,loginPassword,signUpName,signUpEmail,signUpPassword,signUpGender,signUpDob,signUpProfilePath);

@override
String toString() {
  return 'AuthStore(isLoading: $isLoading, loginEmail: $loginEmail, loginPassword: $loginPassword, signUpName: $signUpName, signUpEmail: $signUpEmail, signUpPassword: $signUpPassword, signUpGender: $signUpGender, signUpDob: $signUpDob, signUpProfilePath: $signUpProfilePath)';
}


}
abstract mixin class _$AuthStoreCopyWith<$Res> implements $AuthStoreCopyWith<$Res> {
  factory _$AuthStoreCopyWith(_AuthStore value, $Res Function(_AuthStore) _then) = __$AuthStoreCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, String loginEmail, String loginPassword, String signUpName, String signUpEmail, String signUpPassword, String signUpGender, DateTime? signUpDob, String? signUpProfilePath
});




}
class __$AuthStoreCopyWithImpl<$Res>
    implements _$AuthStoreCopyWith<$Res> {
  __$AuthStoreCopyWithImpl(this._self, this._then);

  final _AuthStore _self;
  final $Res Function(_AuthStore) _then;
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loginEmail = null,Object? loginPassword = null,Object? signUpName = null,Object? signUpEmail = null,Object? signUpPassword = null,Object? signUpGender = null,Object? signUpDob = freezed,Object? signUpProfilePath = freezed,}) {
  return _then(_AuthStore(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loginEmail: null == loginEmail ? _self.loginEmail : loginEmail // ignore: cast_nullable_to_non_nullable
as String,loginPassword: null == loginPassword ? _self.loginPassword : loginPassword // ignore: cast_nullable_to_non_nullable
as String,signUpName: null == signUpName ? _self.signUpName : signUpName // ignore: cast_nullable_to_non_nullable
as String,signUpEmail: null == signUpEmail ? _self.signUpEmail : signUpEmail // ignore: cast_nullable_to_non_nullable
as String,signUpPassword: null == signUpPassword ? _self.signUpPassword : signUpPassword // ignore: cast_nullable_to_non_nullable
as String,signUpGender: null == signUpGender ? _self.signUpGender : signUpGender // ignore: cast_nullable_to_non_nullable
as String,signUpDob: freezed == signUpDob ? _self.signUpDob : signUpDob // ignore: cast_nullable_to_non_nullable
as DateTime?,signUpProfilePath: freezed == signUpProfilePath ? _self.signUpProfilePath : signUpProfilePath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}
