import 'package:isar/isar.dart';
import '../../../models/user_model.dart';

part 'user_collection.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  late String phone;
  late String? email;
  late String firstName;
  late String lastName;
  late String? profileImage;
  late String password; // Add password field
  late DateTime createdAt;
  late DateTime updatedAt;
  late bool isActive;

  User();

  User.fromUserModel(UserModel user) {
    id = int.tryParse(user.id) ?? Isar.autoIncrement;
    phone = user.phone;
    email = user.email;
    firstName = user.firstName;
    lastName = user.lastName;
    profileImage = user.profileImage;
    password = user.password ?? ''; // Add password field
    createdAt = user.createdAt;
    updatedAt = user.updatedAt;
    isActive = user.isActive;
  }

  UserModel toUserModel() {
    return UserModel(
      id: id.toString(),
      phone: phone,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
      password: password, // Add password field
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}
