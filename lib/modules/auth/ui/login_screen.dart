import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  bool isHidden = true;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AuthBloc>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Image.asset(
                //   'assets/welcome.png',
                //   height: 200,
                // ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) {
                    bloc.setLoginTextEvent(email: v);
                  },
                ),
                const SizedBox(height: 16),
                StatefulBuilder(
                  builder: (context, changeState) {
                    return TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            changeState((){isHidden = !isHidden;});
                          },
                          icon: isHidden
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                      obscureText: isHidden,
                      onChanged: (v) {
                        bloc.setLoginTextEvent(password: v);
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    switch (state) {
                      case LoginSuccess():
                        context.go(AppRouter.mainFeed);
                      case AuthError():
                        showMessageDialog(
                          context: context,
                          message: state.error,
                        );
                      default:
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.store.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  bloc.loginEvent();
                                }
                              },
                        child: state.store.isLoading
                            ? CircularProgressIndicator()
                            : const Text('Login'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Don\'t have account?'),
                    TextButton(
                      child: Text('Sign-up'),
                      onPressed: () {
                        context.go(AppRouter.signUp);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
