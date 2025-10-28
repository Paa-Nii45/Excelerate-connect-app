// lib/models/registration.dart
class Registration {
  final String id;
  final String userId;
  final String programId;
  final DateTime registeredAt;
  final String status;
  final int progress;
  final DateTime? completedAt;

  Registration({
    required this.id,
    required this.userId,
    required this.programId,
    required this.registeredAt,
    required this.status,
    required this.progress,
    this.completedAt,
  });

  factory Registration.fromJson(Map<String, dynamic> json) {
    return Registration(
      id: json['id'] as String,
      userId: json['userId'] as String,
      programId: json['programId'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      status: json['status'] as String,
      progress: json['progress'] as int,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'registeredAt': registeredAt.toIso8601String(),
      'status': status,
      'progress': progress,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
}