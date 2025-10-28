class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoURL;
  final DateTime createdAt;
  final UserStats stats;
  final List<String> interests;
  final Map<String, int> skills;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    required this.createdAt,
    required this.stats,
    required this.interests,
    required this.skills,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoURL: json['photoURL'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      interests: List<String>.from(json['interests'] as List),
      skills: Map<String, int>.from(json['skills'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'stats': stats.toJson(),
      'interests': interests,
      'skills': skills,
    };
  }

  String get initials {
    final names = displayName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName.substring(0, 2).toUpperCase();
  }
}

class UserStats {
  final int programsEnrolled;
  final int badgesEarned;
  final int microScholarshipPoints;

  UserStats({
    required this.programsEnrolled,
    required this.badgesEarned,
    required this.microScholarshipPoints,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      programsEnrolled: json['programsEnrolled'] as int,
      badgesEarned: json['badgesEarned'] as int,
      microScholarshipPoints: json['microScholarshipPoints'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'programsEnrolled': programsEnrolled,
      'badgesEarned': badgesEarned,
      'microScholarshipPoints': microScholarshipPoints,
    };
  }
}