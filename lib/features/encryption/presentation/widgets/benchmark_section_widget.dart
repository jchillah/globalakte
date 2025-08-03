import 'package:flutter/material.dart';
import '../../../../shared/widgets/global_button.dart';

/// Widget für die Benchmark-Sektion
class BenchmarkSectionWidget extends StatelessWidget {
  final VoidCallback onRunBenchmark;
  final bool isLoading;

  const BenchmarkSectionWidget({
    super.key,
    required this.onRunBenchmark,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance-Benchmark',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            GlobalButton(
              onPressed: onRunBenchmark,
              text: 'Benchmark ausführen',
              isLoading: isLoading,
            ),
            const SizedBox(height: 16),
            Text(
              'Testet die Verschlüsselungs-Performance mit verschiedenen Algorithmen.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
} 