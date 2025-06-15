import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/utils/global_functions.dart';
import 'package:social_media_app/utils/hash_password.dart';
import 'package:uuid/uuid.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_store.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial(store: AuthStore())) {
    on<_SetLoginTextEvent>(_onSetLoginTextEvent);
    on<_SetSignUpTextEvent>(_onSetSignUpTextEvent);
    on<_UpdateUserProfileEvent>(_onUpdateUserProfileEvent);
    on<_LoginEvent>(_onLoginEvent);
    on<_SignUpEvent>(_onSignUpEvent);
    on<_LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onSetLoginTextEvent(
    _SetLoginTextEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthState.general(
        store: state.store.copyWith(
          loginEmail: event.email ?? state.store.loginEmail,
          loginPassword: event.password ?? state.store.loginPassword,
        ),
      ),
    );
  }

  Future<void> _onSetSignUpTextEvent(
    _SetSignUpTextEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      AuthState.general(
        store: state.store.copyWith(
          signUpDob: event.dob ?? state.store.signUpDob,
          signUpEmail: event.email ?? state.store.signUpEmail,
          signUpGender: event.gender ?? state.store.signUpGender,
          signUpName: event.name ?? state.store.signUpName,
          signUpPassword: event.password ?? state.store.signUpPassword,
          signUpProfilePath: event.profilePath ?? state.store.signUpProfilePath,
        ),
      ),
    );
  }

  Future<void> _onUpdateUserProfileEvent(
    _UpdateUserProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthState.general(store: state.store.copyWith(isLoading: true)));
      final user = UserDb.getUser(getStringAsync(AppConstant.userId));
      final updatedUser = UserModel(
        id: user?.id ?? '',
        name: user?.name ?? '',
        gender: user?.gender ?? '',
        dob: user?.dob ?? DateTime(2000, 01, 01),
        email: user?.email ?? '',
        hashPassword: user?.hashPassword ?? '',
        profilePath: event.imagePath,
      );
      updatedUser.save();
      emit(AuthState.profilePicUpdated(store: state.store.copyWith(isLoading: false,),message:'Profile pic updated.'));
    } catch (e) {
      emit(
        AuthState.authError(
          store: state.store.copyWith(isLoading: false),
          error: 'An error occurred updating profile.',
        ),
      );
    }
  }

  Future<void> _onLoginEvent(_LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.general(store: state.store.copyWith(isLoading: true)));
    try {
      debugPrint('all users - ${UserDb.getAllUsers()}');
      if (UserDb.isEmailAndPasswordValid(
        state.store.loginEmail,
        state.store.loginPassword,
      )) {
        await setLoginStatus(
          UserDb.getUserIdFromEmail(state.store.loginEmail) ?? '',
        );
        emit(
          AuthState.loginSuccess(
            store: state.store.copyWith(
              isLoading: false,
              loginEmail: '',
              loginPassword: '',
            ),
            message: 'Welcome back!',
          ),
        );
      } else {
        emit(
          AuthState.authError(
            store: state.store.copyWith(isLoading: false),
            error: 'Invalid credentials.',
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(
        AuthState.authError(
          store: state.store.copyWith(isLoading: false),
          error: 'Something went wrong. Please try later.',
        ),
      );
    }
  }

  Future<void> _onSignUpEvent(
    _SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.general(store: state.store.copyWith(isLoading: true)));
    try {
      final store = state.store;
      if (UserDb.userExists(store.signUpEmail)) {
        emit(
          AuthState.authError(
            store: store.copyWith(isLoading: false),
            error: 'This email is already registered.',
          ),
        );
      } else {
        final id = const Uuid().v4();
        final user = UserModel(
          id: id,
          name: store.signUpName,
          gender: store.signUpGender,
          dob: store.signUpDob ?? DateTime(2000, 1, 1),
          email: store.signUpEmail,
          hashPassword: hashPassword(store.signUpPassword),
          profilePath: store.signUpProfilePath,
        );
        user.save();
        await setLoginStatus(id);
        emit(
          AuthState.signUpSuccess(
            store: state.store.copyWith(
              isLoading: false,
              signUpPassword: '',
              signUpName: '',
              signUpGender: '',
              signUpEmail: '',
              signUpDob: null,
              signUpProfilePath: null,
            ),
            message: ' You\'re all set up! Welcome aboard.',
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      emit(
        AuthState.authError(
          store: state.store.copyWith(isLoading: false),
          error: 'Something went wrong. Please try later',
        ),
      );
    }
  }

  Future<void> _onLogoutEvent(
    _LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.general(store: state.store.copyWith(isLoading: true)));
    await removeLoginStatus();
    emit(
      AuthState.logOutSuccess(
        store: state.store.copyWith(isLoading: false),
        message: 'Logged out successfully.',
      ),
    );
  }

  void updateUserProfileEvent(String? imagePath) =>
    add(AuthEvent.updateUserProfileEvent(imagePath));


  void loginEvent() {
    add(const AuthEvent.loginEvent());
  }

  void signUpEvent() {
    add(const AuthEvent.signUpEvent());
  }

  void logoutEvent() {
    add(const AuthEvent.logoutEvent());
  }

  void setSignUpTextEvent({
    String? name,
    String? email,
    DateTime? dob,
    String? gender,
    String? password,
    String? profilePath,
  }) {
    add(
      AuthEvent.setSignUpTextEvent(
        name: name,
        email: email,
        dob: dob,
        gender: gender,
        password: password,
        profilePath: profilePath,
      ),
    );
  }

  void setLoginTextEvent({String? email, String? password}) {
    add(AuthEvent.setLoginTextEvent(email: email, password: password));
  }
}
