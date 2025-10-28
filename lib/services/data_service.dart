import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/user.dart';
import '../models/program.dart';
import '../models/announcement.dart';
import '../models/badge.dart' as models;
import '../models/registration.dart';
import '../models/feedback.dart';

class DataService {
  // In-memory data storage
  List<User> _users = [];
  List<Program> _programs = [];
  List<Announcement> _announcements = [];
  List<models.Badge> _badges = [];
  List<models.UserBadge> _userBadges = [];
  List<Registration> _registrations = [];
  List<ProgramFeedback> _feedback = [];

  bool _isLoaded = false;

  // Getters
  List<User> get users => _users;
  List<Program> get programs => _programs;
  List<Announcement> get announcements => _announcements;
  List<models.Badge> get badges => _badges;
  List<models.UserBadge> get userBadges => _userBadges;
  List<Registration> get registrations => _registrations;
  List<ProgramFeedback> get feedbackList => _feedback;

  /// Load all data from JSON file
  Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/mock_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Parse users
      _users = (jsonData['users'] as List)
          .map((json) => User.fromJson(json))
          .toList();

      // Parse programs
      _programs = (jsonData['programs'] as List)
          .map((json) => Program.fromJson(json))
          .toList();

      // Parse announcements
      _announcements = (jsonData['announcements'] as List)
          .map((json) => Announcement.fromJson(json))
          .toList();

      // Parse badges
      _badges = (jsonData['badges'] as List)
          .map((json) => models.Badge.fromJson(json))
          .toList();

      // Parse user badges
      _userBadges = (jsonData['userBadges'] as List)
          .map((json) => models.UserBadge.fromJson(json))
          .toList();

      // Parse registrations
      _registrations = (jsonData['registrations'] as List)
          .map((json) => Registration.fromJson(json))
          .toList();

      // Parse feedback
      _feedback = (jsonData['feedback'] as List)
          .map((json) => ProgramFeedback.fromJson(json))
          .toList();

      _isLoaded = true;
      print('✅ Data loaded successfully');
    } catch (e) {
      print('❌ Error loading data: $e');
      rethrow;
    }
  }

  // User operations
  User? getUserByEmail(String email) {
    try {
      return _users.firstWhere((user) => user.email.toLowerCase() == email.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Program operations
  List<Program> getProgramsByCategory(String? category) {
    if (category == null || category == 'All') {
      return _programs;
    }
    return _programs.where((p) => p.category == category).toList();
  }

  List<Program> searchPrograms(String query) {
    final lowerQuery = query.toLowerCase();
    return _programs.where((p) =>
    p.title.toLowerCase().contains(lowerQuery) ||
        p.description.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  Program? getProgramById(String id) {
    try {
      return _programs.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Program> getFeaturedPrograms() {
    return _programs.where((p) => p.isFeatured).toList();
  }

  // Registration operations
  List<Registration> getUserRegistrations(String userId) {
    return _registrations.where((r) => r.userId == userId).toList();
  }

  Future<Registration> registerForProgram(String userId, String programId) async {
    final registration = Registration(
      id: 'reg_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      programId: programId,
      registeredAt: DateTime.now(),
      status: 'active',
      progress: 0,
      completedAt: null,
    );

    _registrations.add(registration);

    // Update program spots
    final program = getProgramById(programId);
    if (program != null) {
      final index = _programs.indexOf(program);
      _programs[index] = Program(
        id: program.id,
        title: program.title,
        category: program.category,
        categoryColor: program.categoryColor,
        description: program.description,
        duration: program.duration,
        durationHours: program.durationHours,
        startDate: program.startDate,
        difficulty: program.difficulty,
        skills: program.skills,
        rewards: program.rewards,
        thumbnailUrl: program.thumbnailUrl,
        organizationName: program.organizationName,
        spotsAvailable: program.spotsAvailable,
        spotsRemaining: program.spotsRemaining - 1,
        isFeatured: program.isFeatured,
        createdAt: program.createdAt,
      );
    }

    return registration;
  }

  bool isUserRegistered(String userId, String programId) {
    return _registrations.any((r) => r.userId == userId && r.programId == programId);
  }

  // Badge operations
  List<models.Badge> getUserBadges(String userId) {
    final userBadgeIds = _userBadges
        .where((ub) => ub.userId == userId)
        .map((ub) => ub.badgeId)
        .toList();

    return _badges.where((b) => userBadgeIds.contains(b.id)).toList();
  }

  // Announcement operations
  List<Announcement> getRecentAnnouncements({int limit = 10}) {
    final sorted = List<Announcement>.from(_announcements);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted.take(limit).toList();
  }

  // Feedback operations
  Future<void> submitFeedback(ProgramFeedback feedback) async {
    _feedback.add(feedback);
  }

  ProgramFeedback? getProgramFeedback(String userId, String programId) {
    try {
      return _feedback.firstWhere(
              (f) => f.userId == userId && f.programId == programId
      );
    } catch (e) {
      return null;
    }
  }
}