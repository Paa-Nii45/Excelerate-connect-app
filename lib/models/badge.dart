// lib/models/badge.dart
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String rarity;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      rarity: json['rarity'] as String,
    );
  }
}

class UserBadge {
  final String userId;
  final String badgeId;
  final DateTime earnedAt;

  UserBadge({
    required this.userId,
    required this.badgeId,
    required this.earnedAt,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      userId: json['userId'] as String,
      badgeId: json['badgeId'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );
  }
}