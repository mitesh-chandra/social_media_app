import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';

Future<void> setLoginStatus(String id) async{
  await setValue(AppConstant.isLoggedIn, true);
  await setValue(AppConstant.userId, id);
}

Future<void> removeLoginStatus() async{
  await setValue(AppConstant.isLoggedIn, false);
  await setValue(AppConstant.userId, null);
}