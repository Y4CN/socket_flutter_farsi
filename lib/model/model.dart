
class ChatModel {
  String message;
  UserModel user;
  ChatModel({
    required this.message,
    required this.user,
  });

  factory ChatModel.fromJson(Map<String, dynamic> jsonDate) {
    return ChatModel(
      message: jsonDate['Message'],
      user: UserModel.fromJson(jsonDate['User']),
    );
  }
}

class UserModel {
  int id;
  String name;

  UserModel({
    required this.id,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
      id: jsonData['ID'],
      name: jsonData['Name'],
    );
  }
}
