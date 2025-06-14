// import 'package:hive/hive.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:social_media_app/modules/user/db/user_db.dart';
// import 'package:social_media_app/modules/user/model/user_model.dart';
//
// class HiveService{
//
//   HiveService();
//
//   static void registerAdapters(){
//     Hive.registerAdapter(UserModelAdapter());
//   }
//
//   static Future<void> dbInit() async{
//     //call individual db's init here
//     Future.wait([UserDb.init(),]);
//   }
//
//   /// Call once in main() to initialize Hive
//   static Future<void> init() async {
//       final appDocumentDir = await getApplicationDocumentsDirectory();
//       Hive.init(appDocumentDir.path);
//       registerAdapters();
//       await dbInit();
//   }
//
// }
