import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/program_provider.dart';
import '../config/theme.dart';
import '../widgets/custom_button.dart';
import '../models/program.dart';

class ProgramDetailsScreen extends StatefulWidget {
  const ProgramDetailsScreen({super.key});

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
  bool _isRegistering = false;
  bool _isRegistered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final programId = ModalRoute.of(context)!.settings.arguments as String;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final programProvider = Provider.of<ProgramProvider>(context, listen: false);

    _isRegistered = programProvider.isUserRegistered(
      authProvider.currentUser!.id,
      programId,
    );
  }

  Future<void> _handleRegistration(String programId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final programProvider = Provider.of<ProgramProvider>(context, listen: false);

    setState(() => _isRegistering = true);

    final success = await programProvider.registerForProgram(
      authProvider.currentUser!.id,
      programId,
    );

    setState(() => _isRegistering = false);

    if (success && mounted) {
      setState(() => _isRegistered = true);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 48,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Registration Confirmed!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You're all set!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMedium,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'View My Programs',
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Details'),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)!.settings.arguments as String;
    final programProvider = Provider.of<ProgramProvider>(context);
    final program = programProvider.getProgramById(programId);

    if (program == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Program not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Container(
              width: double.infinity,
              height: 150,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'Program Banner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Description Section
                  _buildSection(
                    icon: Icons.description,
                    title: 'DESCRIPTION',
                    child: Text(
                      program.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                        height: 1.6,
                      ),
                    ),
                  ),

                  // Duration Section
                  _buildSection(
                    icon: Icons.access_time,
                    title: 'DURATION & COMMITMENT',
                    child: Text(
                      '${program.duration} | ${program.durationHours}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),

                  // Start Date Section
                  _buildSection(
                    icon: Icons.calendar_today,
                    title: 'START DATE',
                    child: Text(
                      DateFormat('MMMM dd, yyyy').format(program.startDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),

                  // Skills Section
                  _buildSection(
                    icon: Icons.psychology,
                    title: 'SKILLS YOU\'LL GAIN',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: program.skills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EAF6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF5C6BC0),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Rewards Section
                  _buildSection(
                    icon: Icons.emoji_events,
                    title: 'WHAT YOU\'LL EARN',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (program.rewards.badge)
                          const Text(
                            '• Digital badge upon completion',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark,
                              height: 1.6,
                            ),
                          ),
                        Text(
                          '• ${program.rewards.points} micro-scholarship points',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textDark,
                            height: 1.6,
                          ),
                        ),
                        if (program.rewards.certificate)
                          const Text(
                            '• Certificate of completion',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textDark,
                              height: 1.6,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Organization
                  _buildSection(
                    icon: Icons.business,
                    title: 'ORGANIZATION',
                    child: Text(
                      program.organizationName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),

                  // Spots Available
                  if (program.isAlmostFull)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFF57C00),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Only ${program.spotsRemaining} spots remaining!',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF57C00),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  if (_isRegistered)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF4CAF50),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'You are registered for this program',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        CustomButton(
                          text: 'Register Now',
                          onPressed: () => _handleRegistration(program.id),
                          isLoading: _isRegistering,
                        ),
                        const SizedBox(height: 10),
                        CustomButton(
                          text: 'Save for Later',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Program saved to your list!'),
                              ),
                            );
                          },
                          isOutlined: true,
                          icon: Icons.bookmark_border,
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppTheme.textMedium),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textMedium,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}