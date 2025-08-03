// features/accessibility/presentation/screens/accessibility_demo_screen.dart

import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../data/repositories/accessibility_repository_impl.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/repositories/accessibility_repository.dart';
import '../../domain/usecases/accessibility_usecases.dart';
import '../widgets/accessibility_report_widget.dart';
import '../widgets/accessibility_settings_widget.dart';
import '../widgets/accessibility_test_widget.dart';

/// Demo-Screen für Barrierefreiheit und Accessibility
class AccessibilityDemoScreen extends StatefulWidget {
  const AccessibilityDemoScreen({super.key});

  @override
  State<AccessibilityDemoScreen> createState() =>
      _AccessibilityDemoScreenState();
}

class _AccessibilityDemoScreenState extends State<AccessibilityDemoScreen>
    with TickerProviderStateMixin {
  final AccessibilityRepository _accessibilityRepository =
      AccessibilityRepositoryImpl();
  late final GetAccessibilitySettingsUseCase _getSettingsUseCase;
  late final SaveAccessibilitySettingsUseCase _saveSettingsUseCase;
  late final ResetAccessibilitySettingsUseCase _resetSettingsUseCase;
  late final RunAccessibilityTestsUseCase _runTestsUseCase;
  late final CheckWCAGComplianceUseCase _checkWCAGUseCase;
  late final GenerateAccessibilityReportUseCase _generateReportUseCase;

  AccessibilitySettings? _currentSettings;
  List<AccessibilityTestResult> _testResults = [];
  bool _isLoading = false;
  bool _wcagCompliant = false;
  String _accessibilityReport = '';

  @override
  void initState() {
    super.initState();
    _initializeUseCases();
    _loadSettings();
  }

  void _initializeUseCases() {
    _getSettingsUseCase =
        GetAccessibilitySettingsUseCase(_accessibilityRepository);
    _saveSettingsUseCase =
        SaveAccessibilitySettingsUseCase(_accessibilityRepository);
    _resetSettingsUseCase =
        ResetAccessibilitySettingsUseCase(_accessibilityRepository);
    _runTestsUseCase = RunAccessibilityTestsUseCase(_accessibilityRepository);
    _checkWCAGUseCase = CheckWCAGComplianceUseCase(_accessibilityRepository);
    _generateReportUseCase =
        GenerateAccessibilityReportUseCase(_accessibilityRepository);
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);

    try {
      final settings = await _getSettingsUseCase();
      if (!mounted) return;
      setState(() => _currentSettings = settings);
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Laden der Einstellungen: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveSettings(AccessibilitySettings settings) async {
    setState(() => _isLoading = true);

    try {
      final savedSettings = await _saveSettingsUseCase(settings);
      if (!mounted) return;
      setState(() => _currentSettings = savedSettings);
      SnackBarUtils.showSuccessSnackBar(
          context, 'Einstellungen erfolgreich gespeichert');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Speichern der Einstellungen: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resetSettings() async {
    setState(() => _isLoading = true);

    try {
      final resetSettings = await _resetSettingsUseCase();
      if (!mounted) return;
      setState(() => _currentSettings = resetSettings);
      SnackBarUtils.showSuccessSnackBar(
          context, 'Einstellungen erfolgreich zurückgesetzt');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Zurücksetzen der Einstellungen: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _runAccessibilityTests() async {
    setState(() => _isLoading = true);

    try {
      final results = await _runTestsUseCase();
      final wcagCompliant = await _checkWCAGUseCase();
      if (!mounted) return;
      setState(() {
        _testResults = results;
        _wcagCompliant = wcagCompliant;
      });
      SnackBarUtils.showSuccessSnackBar(
          context, 'Accessibility-Tests erfolgreich ausgeführt');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Ausführen der Tests: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _generateReport() async {
    setState(() => _isLoading = true);

    try {
      final report = await _generateReportUseCase();
      if (!mounted) return;
      setState(() => _accessibilityReport = report);
      SnackBarUtils.showSuccessSnackBar(
          context, 'Accessibility-Report erfolgreich generiert');
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
          context, 'Fehler beim Generieren des Reports: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barrierefreiheit & Accessibility'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showAccessibilityInfo,
            tooltip: 'Accessibility-Informationen anzeigen',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentSettings == null
              ? const Center(child: Text('Lade Einstellungen...'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAccessibilityInfo(),
                      const SizedBox(height: 24),
                      AccessibilitySettingsWidget(
                        settings: _currentSettings!,
                        onSettingsChanged: _saveSettings,
                        onResetSettings: _resetSettings,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),
                      AccessibilityTestWidget(
                        testResults: _testResults,
                        wcagCompliant: _wcagCompliant,
                        onRunTests: _runAccessibilityTests,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 24),
                      AccessibilityReportWidget(
                        report: _accessibilityReport,
                        onGenerateReport: _generateReport,
                        isLoading: _isLoading,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildAccessibilityInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.accessibility_new,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Barrierefreiheit & Accessibility',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'GlobalAkte ist für alle Benutzer zugänglich. Hier können Sie '
              'verschiedene Accessibility-Features testen und konfigurieren.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• Screen Reader Unterstützung\n'
              '• Voice Control Integration\n'
              '• High Contrast Mode\n'
              '• Schriftgröße Anpassung\n'
              '• Keyboard Navigation\n'
              '• WCAG-Konformität',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccessibilityInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accessibility-Informationen'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'GlobalAkte ist vollständig barrierefrei gestaltet:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('• Screen Reader Unterstützung für alle UI-Elemente'),
              Text('• Voice Control für Navigation und Aktionen'),
              Text('• High Contrast Mode für bessere Sichtbarkeit'),
              Text('• Skalierbare Schriftgrößen (0.5x - 3.0x)'),
              Text('• Vollständige Tastaturnavigation'),
              Text('• Focus-Indikatoren für bessere Orientierung'),
              Text('• Motion Reduction für empfindliche Benutzer'),
              SizedBox(height: 12),
              Text(
                'WCAG 2.1 AA Konformität:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('• Perceivable: Alle Inhalte sind wahrnehmbar'),
              Text('• Operable: Alle Funktionen sind bedienbar'),
              Text('• Understandable: Alle Inhalte sind verständlich'),
              Text('• Robust: Kompatibel mit assistiven Technologien'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Verstanden'),
          ),
        ],
      ),
    );
  }
}
