import 'package:hive/hive.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:social_media_app/core/app_constant.dart';
import 'package:social_media_app/modules/user/model/user_model.dart';
import 'package:social_media_app/utils/hash_password.dart';

class UserDb {
  static final Box<UserModel> _userBox = Hive.box<UserModel>(AppConstant.userDb);
  static final Box<String> _emailIdBox = Hive.box<String>(AppConstant.emailAndIdDb);

  static Future<void> addUser(UserModel user) async {
    await _userBox.put(user.id, user); // Using user.id as key
    await _emailIdBox.put(user.email, user.id);
  }

  static UserModel? getUser(String id) {
    return _userBox.get(id);
  }

  static List<UserModel> getAllUsers() {
    return _userBox.values.toList();
  }

  static Future<void> deleteUser(String id) async {
    await _userBox.delete(id);
  }

  static Future<void> clearAll() async {
    await _userBox.clear();
  }

  static bool userExists(String email) {
    return _emailIdBox.containsKey(email);
  }

  static String? getUserIdFromEmail(String email) {
    return _emailIdBox.get(email);
  }

  static UserModel? getCurrentUser() {
    return getUser(getStringAsync(AppConstant.userId));
  }

  static bool isEmailAndPasswordValid(String email, String password) {
    final userId = _emailIdBox.get(email);
    if (userId == null) return false;

    final user = _userBox.get(userId);
    if (user == null) return false;

    final hashedInput = hashPassword(password);
    return user.hashPassword == hashedInput;
  }
}
