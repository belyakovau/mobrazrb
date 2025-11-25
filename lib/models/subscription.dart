// Модель абонемента
class Subscription {
  final int? id;
  final int clientId;
  final int subscriptionTypeId;
  final DateTime startDate;
  final DateTime endDate;
  final int visitsRemaining;
  final bool isActive;
  final double price;
  final DateTime? createdAt;

  Subscription({
    this.id,
    required this.clientId,
    required this.subscriptionTypeId,
    required this.startDate,
    required this.endDate,
    required this.visitsRemaining,
    required this.isActive,
    required this.price,
    this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'],
      clientId: json['client_id'],
      subscriptionTypeId: json['subscription_type_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      visitsRemaining: json['visits_remaining'] ?? 0,
      isActive: json['is_active'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'subscription_type_id': subscriptionTypeId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'visits_remaining': visitsRemaining,
      'is_active': isActive,
      'price': price,
    };
  }
}

// Модель типа абонемента
class SubscriptionType {
  final int? id;
  final String name;
  final double price;
  final int durationDays;
  final int? visits; // null или -1 означает безлимит
  final bool isActive;

  SubscriptionType({
    this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    this.visits,
    this.isActive = true,
  });

  factory SubscriptionType.fromJson(Map<String, dynamic> json) {
    return SubscriptionType(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      durationDays: json['duration_days'] ?? 30,
      visits: json['visits'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'duration_days': durationDays,
      'visits': visits,
      'is_active': isActive,
    };
  }
}


