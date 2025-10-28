import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/program_provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';
import '../widgets/custom_button.dart';
import '../models/feedback.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _suggestionsController = TextEditingController();

  int _rating = 0;
  bool _wouldRecommend = true;

  @override
  void dispose() {
    _feedbackController.dispose();
    _suggestionsController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(String programId) async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final feedback = ProgramFeedback(
        id: 'feedback_${DateTime.now().millisecondsSinceEpoch}',
        userId: authProvider.currentUser!.id,
        programId: programId,
        rating: _rating,
        feedback: _feedbackController.text,
        suggestions: _suggestionsController.text,
        wouldRecommend: _wouldRecommend,
        submittedAt: DateTime.now(),
      );

      await userProvider.submitFeedback(feedback);

      if (mounted) {
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
                  'Thank You!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your feedback has been submitted successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMedium,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Back to Profile',
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to profile
                  },
                ),
              ],
            ),
          ),
        );
      }
    } else if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final programId = ModalRoute.of(context)!.settings.arguments as String;
    final programProvider = Provider.of<ProgramProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final program = programProvider.getProgramById(programId);
    final existingFeedback = userProvider.getProgramFeedback(
      authProvider.currentUser!.id,
      programId,
    );

    if (program == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('Program not found'),
        ),
      );
    }

    // If feedback already exists, show it
    if (existingFeedback != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Feedback'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You have already submitted feedback for this program.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 20),

              _buildViewOnlySection(
                title: 'Program',
                child: Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                  ),
                ),
              ),

              _buildViewOnlySection(
                title: 'Your Rating',
                child: Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < existingFeedback.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: const Color(0xFFFFD700),
                      size: 32,
                    );
                  }),
                ),
              ),

              _buildViewOnlySection(
                title: 'Your Feedback',
                child: Text(
                  existingFeedback.feedback,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                    height: 1.6,
                  ),
                ),
              ),

              _buildViewOnlySection(
                title: 'Your Suggestions',
                child: Text(
                  existingFeedback.suggestions,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textDark,
                    height: 1.6,
                  ),
                ),
              ),

              _buildViewOnlySection(
                title: 'Would You Recommend?',
                child: Text(
                  existingFeedback.wouldRecommend
                      ? '✓ Yes, definitely!'
                      : 'Maybe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: existingFeedback.wouldRecommend
                        ? const Color(0xFF4CAF50)
                        : AppTheme.textMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show feedback form
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'How was your experience?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 10),

              // Program Name
              Text(
                program.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textMedium,
                ),
              ),

              const SizedBox(height: 30),

              // Rating Stars
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          index < _rating ? Icons.star : Icons.star_border,
                          color: const Color(0xFFFFD700),
                          size: 36,
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // Feedback Section
              _buildSection(
                icon: Icons.comment,
                title: 'TELL US MORE',
                child: TextFormField(
                  controller: _feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts about this program...',
                    filled: true,
                    fillColor: AppTheme.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryPurple,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please provide your feedback';
                    }
                    return null;
                  },
                ),
              ),

              // Suggestions Section
              _buildSection(
                icon: Icons.lightbulb,
                title: 'SUGGESTIONS',
                child: TextFormField(
                  controller: _suggestionsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Any suggestions for improvement?',
                    filled: true,
                    fillColor: AppTheme.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.borderColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryPurple,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Would Recommend Section
              _buildSection(
                icon: Icons.thumb_up,
                title: 'WOULD YOU RECOMMEND?',
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _wouldRecommend = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _wouldRecommend
                              ? AppTheme.primaryPurple
                              : Colors.white,
                          foregroundColor: _wouldRecommend
                              ? Colors.white
                              : AppTheme.primaryPurple,
                          side: BorderSide(
                            color: _wouldRecommend
                                ? AppTheme.primaryPurple
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Yes, definitely! 👍',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _wouldRecommend = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_wouldRecommend
                              ? AppTheme.primaryPurple
                              : Colors.white,
                          foregroundColor: !_wouldRecommend
                              ? Colors.white
                              : AppTheme.primaryPurple,
                          side: BorderSide(
                            color: !_wouldRecommend
                                ? AppTheme.primaryPurple
                                : AppTheme.borderColor,
                            width: 2,
                          ),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Maybe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  return CustomButton(
                    text: 'Submit Feedback',
                    onPressed: () => _submitFeedback(program.id),
                    isLoading: userProvider.isLoading,
                  );
                },
              ),
            ],
          ),
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
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildViewOnlySection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMedium,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}