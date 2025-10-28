import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/program_provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../widgets/program_card.dart';
import '../widgets/bottom_nav_bar.dart';

class ProgramListingScreen extends StatefulWidget {
  const ProgramListingScreen({super.key});

  @override
  State<ProgramListingScreen> createState() => _ProgramListingScreenState();
}

class _ProgramListingScreenState extends State<ProgramListingScreen> {
  final _searchController = TextEditingController();
  int _currentNavIndex = 1;

  final List<String> _categories = [
    'All',
    'Internship',
    'Event',
    'Competition',
    'Masterclass',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNavigation(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0: // Home
        Navigator.pop(context);
        break;
      case 1: // Programs - already here
        break;
      case 2: // Learning
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Learning section coming soon!')),
        );
        break;
      case 3: // Profile
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final programProvider = Provider.of<ProgramProvider>(context);
    final programs = programProvider.filteredPrograms;
    final selectedCategory = programProvider.selectedCategory ?? 'All';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Programs'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                programProvider.setSearchQuery(value);
              },
              decoration: InputDecoration(
                hintText: '🔍 Search programs...',
                filled: true,
                fillColor: AppTheme.backgroundLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: AppTheme.primaryPurple, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    programProvider.setSearchQuery('');
                  },
                )
                    : null,
              ),
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      programProvider.setCategory(selected ? category : null);
                    },
                    selectedColor: AppTheme.primaryPurple,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textMedium,
                    ),
                    side: const BorderSide(
                      color: AppTheme.borderColor,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // Programs Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Available Programs (${programs.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Programs List
          Expanded(
            child: programs.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: AppTheme.textLight,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No programs found',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      _searchController.clear();
                      programProvider.clearFilters();
                    },
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];
                return ProgramCard(
                  program: program,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.programDetails,
                      arguments: program.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _handleNavigation,
      ),
    );
  }
}