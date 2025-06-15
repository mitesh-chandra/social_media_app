import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/post/model/post_model.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';

class DB{
 Future<void> init() async{
   final appDocumentDir = await getApplicationDocumentsDirectory();
   Hive.init(appDocumentDir.path);
   Hive.registerAdapter(UserModelAdapter());
   Hive.registerAdapter(PostModelAdapter());
   Hive.registerAdapter(MediaModelAdapter());
   Hive.registerAdapter(CommentModelAdapter());
   Hive.registerAdapter(LikeModelAdapter());
   Hive.registerAdapter(MediaTypeAdapter());
   Hive.registerAdapter(RichTextContentAdapter());
   Hive.registerAdapter(TextFormattingAdapter());
   Hive.registerAdapter(TextSegmentAdapter());
   await Future.wait([Hive.openBox<UserModel>(AppConstant.userDb),Hive.openBox<String>(AppConstant.emailAndIdDb),Hive.openBox<PostModel>(AppConstant.postDb)]);
 }
}