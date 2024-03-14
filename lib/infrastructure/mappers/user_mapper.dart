import '../../domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'] ?? '');
}
