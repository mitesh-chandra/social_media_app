import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/utils/message_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:BlocConsumer<AuthBloc,AuthState>(
          listener: (context,state){
            switch(state){
              case SignUpSuccess():
                context.go(AppRouter.mainFeed);
                toast(state.message);
              case AuthError():
                showMessageDialog(context: context,message: state.error);
              default:
            }
          },
          builder: (context,state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Text('Let\'s get started!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Please enter your name'
                          : null,
                      onChanged: (v){
                        context.read<AuthBloc>().add(AuthEvent.setSignUpTextEvent(
                          name: v,
                        ));
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      onChanged: (v){
                        context.read<AuthBloc>().add(AuthEvent.setSignUpTextEvent(
                          email: v,
                        ));
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      value: state.store.signUpGender.isNotEmpty ?state.store.signUpGender:null,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(AuthEvent.setSignUpTextEvent(
                          gender: value,
                        ));
                      },
                      validator: (value) =>
                      value == null ? 'Please select your gender' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) =>
                      (value == null || value.length < 6)
                          ? 'Password must be at least 6 characters'
                          : null,
                      onChanged: (v){
                        context.read<AuthBloc>().add(AuthEvent.setSignUpTextEvent(
                          password: v,
                        ));
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) =>
                      (value == null)
                          ? 'Please confirm your password'
                          : value == state.store.signUpPassword ? null : 'This must match the password above.',
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:state.store.isLoading ? null : () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(AuthEvent.signUpEvent());
                          }
                        },
                        child: state.store.isLoading ? CircularProgressIndicator() : const Text('Sign Up'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Already have account?'),
                        TextButton(child: Text('login'),onPressed: (){
                          context.go(AppRouter.login);
                        },),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
