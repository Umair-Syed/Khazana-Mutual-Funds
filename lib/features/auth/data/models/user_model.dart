import 'package:khazana_mutual_funds/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.uid, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(uid: json['id'] as String, email: json['email'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'id': uid, 'email': email};
  }
}
