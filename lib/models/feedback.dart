// lib/models/feedback.dart
class ProgramFeedback {
  final String id;
  final String userId;
  final String programId;
  final int rating;
  final String feedback;
  final String suggestions;
  final bool wouldRecommend;
  final DateTime submittedAt;

  ProgramFeedback({
    required this.id,
    required this.userId,
    required this.programId,
    required this.rating,
    required this.feedback,
    required this.suggestions,
    required this.wouldRecommend,
    required this.submittedAt,
  });

  factory ProgramFeedback.fromJson(Map<String, dynamic> json) {
    return ProgramFeedback(
      id: json['id'] as String,
      userId: json['userId'] as String,
      programId: json['programId'] as String,
      rating: json['rating'] as int,
      feedback: json['feedback'] as String,
      suggestions: json['suggestions'] as String,
      wouldRecommend: json['wouldRecommend'] as bool,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'rating': rating,
      'feedback': feedback,
      'suggestions': suggestions,
      'wouldRecommend': wouldRecommend,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}