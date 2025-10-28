import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/program_provider.dart';
import '../providers/user_provider.dart';
import '../config/routes.dart';
import '../models/user.dart';
import '../widgets/programs_section.dart';
import '../widgets/announcements_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.programListing);
        break;
      case 2:
        if (AppRoutes.learning != null) {
          Navigator.pushNamed(context, AppRoutes.learning!);
        }
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final programProvider = Provider.of<ProgramProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = authProvider.currentUser!;
    final featuredPrograms = programProvider.featuredPrograms;
    final announcements = userProvider.getRecentAnnouncements();

    return Scaffold(
      drawer: _buildDrawer(context, user),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'X-celerate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF005080),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: const Icon(Icons.person, color: Colors.black54),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF5F7FA),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Hi ${user.displayName.split(' ')[0]} 👋',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Accelerate your career with internships!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              _sectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('🌟 Recommended Programs', onViewAll: () {
                      Navigator.pushNamed(context, AppRoutes.programListing);
                    }),
                    ProgramsSection(
                      programs: featuredPrograms,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.programListing),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _sectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('📢 Announcements & Updates'),
                    AnnouncementsSection(announcements: announcements),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.programListing),
        label: const Text('New Internship'),
        icon: const Icon(Icons.add_to_photos_rounded),
        backgroundColor: const Color(0xFF005080),
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF005080),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Programs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: 'Learning'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        if (onViewAll != null)
          TextButton(
            onPressed: onViewAll,
            child: const Text('View All',
                style: TextStyle(color: Color(0xFF005080))),
          ),
      ],
    );
  }

  Widget _sectionContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDrawer(BuildContext context, User user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF005080)),
            child: Text('Welcome, ${user.displayName.split(' ')[0]}',
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('Programs'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.programListing),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Learning'),
            onTap: () {
              if (AppRoutes.learning != null) {
                Navigator.pushNamed(context, AppRoutes.learning!);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
        ],
      ),
    );
  }
}
