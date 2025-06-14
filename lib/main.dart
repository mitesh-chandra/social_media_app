import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/core/Theme/app_theme.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/core/dependency_injection.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/data/hive/hive_service.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/utils/app_bloc_observer.dart';

import 'package:social_media_app/data/db/db.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await DB().init();
  await initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    setupLocator();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<PostBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstant.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.appRoutes,
      ),
    );
  }
}