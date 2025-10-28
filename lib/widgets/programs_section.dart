import 'package:flutter/material.dart';
import '../models/program.dart';
import 'program_card.dart';

class ProgramsSection extends StatelessWidget {
  final List<Program> programs;
  final VoidCallback? onTap;

  const ProgramsSection({
    super.key,
    required this.programs,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (programs.isEmpty) {
      return const Text(
        'No recommended programs at the moment.',
        style: TextStyle(color: Colors.black54),
      );
    }

    return SizedBox(
      height: 320, // ✅ Ensures enough space for image + content
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: programs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final program = programs[index];
          return SizedBox(
            width: 280, // ✅ Controls card width for consistent layout
            child: ProgramCard(
              program: program,
              onTap: () => onTap?.call(),
            ),
          );
        },
      ),
    );
  }
}
