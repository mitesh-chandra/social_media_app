import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/route/app_route.dart';
import 'package:social_media_app/modules/post/bloc/post_bloc.dart';
import 'package:social_media_app/modules/post/ui/post_card.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/modules/auth/bloc/auth_bloc.dart';

class MainFeedScreen extends StatefulWidget {
  const MainFeedScreen({super.key});

  @override
  State<MainFeedScreen> createState() => _MainFeedScreenState();
}

class _MainFeedScreenState extends State<MainFeedScreen> {
  late final UserModel? currentUser;
  @override
  void initState() {
    currentUser = UserDb.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: (){context.push(AppRouter.createPost);},child: Icon(Icons.add),),
      appBar: AppBar(title: Text('Social App'),actions: [
        PopupMenuButton(
          icon: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              currentUser?.name.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              enabled: false,
              child: Text('Hi, ${currentUser?.name.toUpperCase() ?? 'USER'}',style: const TextStyle(color: Colors.black),),
            ),
            const PopupMenuDivider(indent: 4,endIndent: 4,),
            PopupMenuItem(
              child: const Row(
                children: [
                  Icon(Icons.logout,color: Colors.redAccent,),
                  SizedBox(width: 8),
                  Text('Sign Out',style: TextStyle(color: Colors.redAccent,),),
                ],
              ),
              onTap: () {
                context.read<AuthBloc>().logoutEvent();
              },
            ),
          ],
        ),
      ],),
      body: BlocListener<AuthBloc,AuthState>(listener:(context,state){
        switch(state){
          case LogOutSuccess():
            context.go(AppRouter.login);
            toast(state.message);
          default:
        }
      },child: RefreshIndicator(
        onRefresh: () async{
          context.read<PostBloc>().fetchPostsEvent();
        },
        child: SafeArea(child: BlocConsumer<PostBloc,PostState>(
         listener: (context,state){
           switch(state){
             case PostDeleted():
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Post deleted.')),
               );
             default:
           }
         },
          builder: (context,state) {
            return state.store.postList.isEmpty ? Center(child: Text('No post yet.'),) :ListView.builder(
              itemCount: state.store.postList.length,
                itemBuilder: (context,index){
              final post = state.store.postList[index];
              return PostCard(
                post: post,
                isLiked: post.likes.any((like)=>like.userId == UserDb.getCurrentUser()?.id),
              );
            });
          }
        )),
      )),
    );
  }
}
