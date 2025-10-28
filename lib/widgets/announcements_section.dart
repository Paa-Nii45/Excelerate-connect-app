import 'package:flutter/material.dart';
import '../models/announcement.dart';

class AnnouncementsSection extends StatelessWidget {
  final List<Announcement> announcements;
  const AnnouncementsSection({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No announcements yet',
            style: TextStyle(color: Colors.white70)),
      );
    }

    return Column(
      children: announcements.map((announcement) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          elevation: 1,
          child: ListTile(
            leading: Icon(Icons.notifications_active_rounded,
                color: Theme.of(context).colorScheme.tertiary),
            title: Text(announcement.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(announcement.description),
            trailing: Text(announcement.timeAgo,
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Viewing announcement: ${announcement.title}')),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
