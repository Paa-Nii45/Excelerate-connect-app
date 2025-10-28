// lib/providers/program_provider.dart
import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/program.dart';
import '../models/registration.dart';

class ProgramProvider with ChangeNotifier {
  final DataService _dataService;

  String? _selectedCategory;
  String _searchQuery = '';
  List<Program> _filteredPrograms = [];
  bool _isLoading = false;

  ProgramProvider(this._dataService) {
    _filteredPrograms = _dataService.programs;
  }

  List<Program> get allPrograms => _dataService.programs;
  List<Program> get filteredPrograms => _filteredPrograms;
  List<Program> get featuredPrograms => _dataService.getFeaturedPrograms();
  String? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void setCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void _applyFilters() {
    List<Program> result = _dataService.programs;

    // Apply category filter
    if (_selectedCategory != null && _selectedCategory != 'All') {
      result = result.where((p) => p.category == _selectedCategory).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result.where((p) =>
      p.title.toLowerCase().contains(query) ||
          p.description.toLowerCase().contains(query)
      ).toList();
    }

    _filteredPrograms = result;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _searchQuery = '';
    _filteredPrograms = _dataService.programs;
    notifyListeners();
  }

  Program? getProgramById(String id) {
    return _dataService.getProgramById(id);
  }

  Future<bool> registerForProgram(String userId, String programId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _dataService.registerForProgram(userId, programId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  bool isUserRegistered(String userId, String programId) {
    return _dataService.isUserRegistered(userId, programId);
  }
}