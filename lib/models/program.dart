import 'package:flutter/material.dart';

class Program {
  final String id;
  final String title;
  final String category;
  final Map<String, String> categoryColor;
  final String description;
  final String duration;
  final String durationHours;
  final DateTime startDate;
  final String difficulty;
  final List<String> skills;
  final ProgramRewards rewards;
  final String thumbnailUrl; // made non-nullable with fallback
  final String organizationName;
  final int spotsAvailable;
  final int spotsRemaining;
  final bool isFeatured;
  final DateTime createdAt;

  Program({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.description,
    required this.duration,
    required this.durationHours,
    required this.startDate,
    required this.difficulty,
    required this.skills,
    required this.rewards,
    required this.thumbnailUrl,
    required this.organizationName,
    required this.spotsAvailable,
    required this.spotsRemaining,
    required this.isFeatured,
    required this.createdAt,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    const defaultImage =
        'https://images.unsplash.com/photo-1498050108023-c5249f4df085';
    const programImageMap = {
      'Social Media Marketing Internship':
          'https://plus.unsplash.com/premium_photo-1681841957049-37fed0a9ba55?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8U29jaWFsJTIwTWVkaWElMjBNYXJrZXRpbmclMjBJbnRlcm5zaGlwfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
      'AI Marketing Internship':
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8QUklMjBNYXJrZXRpbmd8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&q=60&w=500',
      'Data Analytics with Python':
          'https://images.unsplash.com/photo-1573496528681-9b0f4fb0c660?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZGF0YSUyMGFuYWx5dGljcyUyMHdpdGglMjBweXRob24lMjBwcm9ncmFtbWluZ3xlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&q=60&w=500',
      'Photography: Global Perspectives':
          'https://plus.unsplash.com/premium_photo-1663088812416-587ebe6501bf?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fFBob3RvZ3JhcGh5JTNBJTIwR2xvYmFsJTIwUGVyc3BlY3RpdmVzfGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
      'UX Design Masterclass':
          'https://images.unsplash.com/photo-1581291518633-83b4ebd1d83e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHVpJTIwZGVzaWdufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
      'Startup Pitch Competition':
          'https://images.unsplash.com/photo-1523582407565-efee5cf4a353?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fFN0YXJ0dXAlMjBQaXRjaCUyMENvbXBldGl0aW9ufGVufDB8fDB8fHww&auto=format&fit=crop&q=60&w=500',
    };

    final title = json['title'] as String;
    final fallbackImage = programImageMap[title] ?? defaultImage;

    return Program(
      id: json['id'] as String,
      title: title,
      category: json['category'] as String,
      categoryColor: Map<String, String>.from(json['categoryColor'] as Map),
      description: json['description'] as String,
      duration: json['duration'] as String,
      durationHours: json['durationHours'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      difficulty: json['difficulty'] as String,
      skills: List<String>.from(json['skills'] as List),
      rewards: ProgramRewards.fromJson(json['rewards'] as Map<String, dynamic>),
      thumbnailUrl: (json['thumbnailUrl'] as String?) ?? fallbackImage,
      organizationName: json['organizationName'] as String,
      spotsAvailable: json['spotsAvailable'] as int,
      spotsRemaining: json['spotsRemaining'] as int,
      isFeatured: json['isFeatured'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'categoryColor': categoryColor,
      'description': description,
      'duration': duration,
      'durationHours': durationHours,
      'startDate': startDate.toIso8601String(),
      'difficulty': difficulty,
      'skills': skills,
      'rewards': rewards.toJson(),
      'thumbnailUrl': thumbnailUrl,
      'organizationName': organizationName,
      'spotsAvailable': spotsAvailable,
      'spotsRemaining': spotsRemaining,
      'isFeatured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Color get categoryBgColor {
    return Color(
        int.parse(categoryColor['background']!.substring(1), radix: 16) +
            0xFF000000);
  }

  Color get categoryTextColor {
    return Color(
        int.parse(categoryColor['text']!.substring(1), radix: 16) + 0xFF000000);
  }

  String get formattedStartDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[startDate.month - 1]} ${startDate.day}';
  }

  bool get isAlmostFull {
    return (spotsRemaining / spotsAvailable) < 0.2;
  }
}

class ProgramRewards {
  final bool badge;
  final int points;
  final bool certificate;

  ProgramRewards({
    required this.badge,
    required this.points,
    required this.certificate,
  });

  factory ProgramRewards.fromJson(Map<String, dynamic> json) {
    return ProgramRewards(
      badge: json['badge'] as bool,
      points: json['points'] as int,
      certificate: json['certificate'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'badge': badge,
      'points': points,
      'certificate': certificate,
    };
  }
}
