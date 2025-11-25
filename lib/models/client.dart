// Модель клиента
class Client {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Client({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.createdAt,
    this.updatedAt,
  });

  // Преобразование из JSON (из Supabase)
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Преобразование в JSON (для Supabase)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}


