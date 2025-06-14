import 'package:get_it/get_it.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt..registerFactory<AuthBloc>(() => AuthBloc())..registerFactory<PostBloc>(() => PostBloc());
}
