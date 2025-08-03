// features/legal_assistant_ai/presentation/widgets/legal_analysis_widget.dart
import 'package:flutter/material.dart';

import '../../../../shared/utils/snackbar_utils.dart';
import '../../../../shared/widgets/global_button.dart';
import '../../../../shared/widgets/global_input.dart';
import '../../domain/usecases/legal_ai_usecases.dart';

/// Widget für die rechtliche Dokumenten-Analyse
class LegalAnalysisWidget extends StatefulWidget {
  final AnalyzeLegalDocumentUseCase analyzeDocumentUseCase;
  final bool isLoading;

  const LegalAnalysisWidget({
    super.key,
    required this.analyzeDocumentUseCase,
    required this.isLoading,
  });

  @override
  State<LegalAnalysisWidget> createState() => _LegalAnalysisWidgetState();
}

class _LegalAnalysisWidgetState extends State<LegalAnalysisWidget> {
  final TextEditingController _documentController = TextEditingController();
  Map<String, dynamic>? _analysisResult;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeSampleDocument();
  }

  void _initializeSampleDocument() {
    _documentController.text = '''
Mietvertrag

Zwischen dem Vermieter Max Mustermann, Musterstraße 1, 12345 Musterstadt,
und dem Mieter Anna Schmidt, Hauptstraße 10, 12345 Musterstadt,
wird folgender Mietvertrag geschlossen:

§ 1 Mietobjekt
Die Wohnung in der Musterstraße 1, 3. Stock, 80 qm, wird vermietet.

§ 2 Mietzins
Die monatliche Miete beträgt 800 Euro zuzüglich Nebenkosten.

§ 3 Laufzeit
Der Vertrag beginnt am 01.01.2024 und läuft unbefristet.

§ 4 Kündigung
Eine Kündigung ist mit 3-monatiger Frist möglich.

Unterschriften:
Vermieter: _________________
Mieter: _________________
    ''';
  }

  @override
  void dispose() {
    _documentController.dispose();
    super.dispose();
  }

  Future<void> _analyzeDocument() async {
    if (_documentController.text.trim().isEmpty) {
      SnackBarUtils.showErrorSnackBar(
        context,
        'Bitte geben Sie ein Dokument zur Analyse ein',
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final result =
          await widget.analyzeDocumentUseCase(_documentController.text);

      if (!mounted) return;

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
      });

      SnackBarUtils.showSuccessSnackBar(
        context,
        'Dokument erfolgreich analysiert',
      );
    } catch (e) {
      if (!mounted) return;
      SnackBarUtils.showErrorSnackBar(
        context,
        'Fehler bei der Dokument-Analyse: $e',
      );
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dokument-Analyse',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Dokument-Eingabe
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dokument zur Analyse',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  GlobalTextField(
                    controller: _documentController,
                    label: 'Dokument-Text',
                    hint: 'Fügen Sie hier Ihr rechtliches Dokument ein...',
                    maxLines: 12,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Analysieren-Button
          SizedBox(
            width: double.infinity,
            child: GlobalButton(
              onPressed:
                  widget.isLoading || _isAnalyzing ? null : _analyzeDocument,
              text: 'Dokument analysieren',
              isLoading: _isAnalyzing,
            ),
          ),

          const SizedBox(height: 16),

          // Analyse-Ergebnisse
          if (_analysisResult != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Analyse-Ergebnisse',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Statistiken
                    _buildAnalysisSection(
                      'Statistiken',
                      [
                        'Wörter: ${_analysisResult!['word_count']}',
                        'Absätze: ${_analysisResult!['paragraph_count']}',
                        'Vertrauenswert: ${(_analysisResult!['confidence_score'] * 100).toStringAsFixed(1)}%',
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Rechtliche Begriffe
                    if (_analysisResult!['legal_terms'] != null)
                      _buildAnalysisSection(
                        'Rechtliche Begriffe',
                        (_analysisResult!['legal_terms'] as List)
                            .cast<String>(),
                      ),

                    const SizedBox(height: 16),

                    // Empfehlungen
                    if (_analysisResult!['recommendations'] != null)
                      _buildAnalysisSection(
                        'Empfehlungen',
                        (_analysisResult!['recommendations'] as List)
                            .cast<String>(),
                        icon: Icons.lightbulb,
                        color: Colors.orange,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisSection(
    String title,
    List<String> items, {
    IconData icon = Icons.analytics,
    Color color = Colors.blue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(left: 28, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
      ],
    );
  }
}
