import 'package:hive/hive.dart';
import 'package:social_media_app/modules/user/db/user_db.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String gender;

  @HiveField(4)
  final DateTime dob;

  @HiveField(5)
  final String hashPassword;

  UserModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
    required this.hashPassword,
  });

  @override
  Future<void> delete() async{
    await UserDb.deleteUser(id);
  }

  @override
  Future<void> save() async{
    await UserDb.addUser(this);
  }
}
