// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/badge.dart' as models;
import '../models/registration.dart';
import '../models/program.dart';
import '../models/announcement.dart';
import '../models/feedback.dart';

class UserProvider with ChangeNotifier {
  final DataService _dataService;
  bool _isLoading = false;

  UserProvider(this._dataService);

  bool get isLoading => _isLoading;

  List<models.Badge> getUserBadges(String userId) {
    return _dataService.getUserBadges(userId);
  }

  List<Registration> getUserRegistrations(String userId) {
    return _dataService.getUserRegistrations(userId);
  }

  List<Program> getUserPrograms(String userId) {
    final registrations = _dataService.getUserRegistrations(userId);
    return registrations
        .map((r) => _dataService.getProgramById(r.programId))
        .whereType<Program>()
        .toList();
  }

  List<Announcement> getRecentAnnouncements() {
    return _dataService.getRecentAnnouncements(limit: 5);
  }

  Future<void> submitFeedback(ProgramFeedback feedback) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    await _dataService.submitFeedback(feedback);

    _isLoading = false;
    notifyListeners();
  }

  ProgramFeedback? getProgramFeedback(String userId, String programId) {
    return _dataService.getProgramFeedback(userId, programId);
  }
}