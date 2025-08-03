// features/accessibility/presentation/widgets/accessibility_test_widget.dart

import 'package:flutter/material.dart';

import '../../domain/entities/accessibility_settings.dart';

/// Widget für Accessibility-Tests
class AccessibilityTestWidget extends StatelessWidget {
  final List<AccessibilityTestResult> testResults;
  final bool wcagCompliant;
  final VoidCallback onRunTests;
  final bool isLoading;

  const AccessibilityTestWidget({
    super.key,
    required this.testResults,
    required this.wcagCompliant,
    required this.onRunTests,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.quiz,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Accessibility-Tests',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                if (testResults.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: wcagCompliant ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      wcagCompliant ? 'WCAG-Konform' : 'Nicht WCAG-Konform',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (testResults.isEmpty)
              _buildEmptyState()
            else
              _buildTestResults(),
            const SizedBox(height: 16),
            _buildRunTestsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 48,
            color: Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            'Noch keine Tests ausgeführt',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Klicken Sie auf "Tests ausführen" um die Accessibility-Tests zu starten.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResults() {
    final passedTests = testResults.where((test) => test.passed).length;
    final totalTests = testResults.length;
    final successRate = (passedTests / totalTests * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              passedTests == totalTests ? Icons.check_circle : Icons.warning,
              color: passedTests == totalTests ? Colors.green : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Ergebnisse: $passedTests von $totalTests Tests bestanden ($successRate%)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: passedTests == totalTests ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...testResults.map((test) => _buildTestResultItem(test)),
      ],
    );
  }

  Widget _buildTestResultItem(AccessibilityTestResult test) {
    return Semantics(
      label: '${test.testName} Test Ergebnis',
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: test.passed ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: test.passed ? Colors.green[200]! : Colors.red[200]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              test.passed ? Icons.check_circle : Icons.error,
              color: test.passed ? Colors.green : Colors.red,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.testName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    test.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (test.errorMessage != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Fehler: ${test.errorMessage}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.red[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: test.passed ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                test.passed ? 'Bestanden' : 'Fehlgeschlagen',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunTestsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onRunTests,
        icon: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.play_arrow),
        label: Text(isLoading ? 'Tests laufen...' : 'Tests ausführen'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
