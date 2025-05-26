class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  
  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });
  
  // Создание модели из Map (например, при получении данных с сервера или из SharedPreferences)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
    );
  }
  
  // Преобразование модели в Map (для сохранения в SharedPreferences или отправки на сервер)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
    };
  }
  
  // Копирование модели с возможностью изменения полей
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}