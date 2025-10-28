// lib/models/announcement.dart
class Announcement {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String priority;
  final String? relatedProgramId;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.priority,
    this.relatedProgramId,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      priority: json['priority'] as String,
      relatedProgramId: json['relatedProgramId'] as String?,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
  }
}