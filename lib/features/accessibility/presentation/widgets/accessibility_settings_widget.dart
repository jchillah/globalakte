// features/accessibility/presentation/widgets/accessibility_settings_widget.dart

import 'package:flutter/material.dart';

import '../../domain/entities/accessibility_settings.dart';

/// Widget für Accessibility-Einstellungen
class AccessibilitySettingsWidget extends StatefulWidget {
  final AccessibilitySettings settings;
  final Function(AccessibilitySettings) onSettingsChanged;
  final VoidCallback onResetSettings;
  final bool isLoading;

  const AccessibilitySettingsWidget({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onResetSettings,
    required this.isLoading,
  });

  @override
  State<AccessibilitySettingsWidget> createState() =>
      _AccessibilitySettingsWidgetState();
}

class _AccessibilitySettingsWidgetState
    extends State<AccessibilitySettingsWidget> {
  late AccessibilitySettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  @override
  void didUpdateWidget(AccessibilitySettingsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings) {
      _currentSettings = widget.settings;
    }
  }

  void _updateSettings() {
    widget.onSettingsChanged(_currentSettings);
  }

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
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Accessibility-Einstellungen',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: widget.isLoading ? null : widget.onResetSettings,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Zurücksetzen'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildScreenReaderSection(),
            const SizedBox(height: 16),
            _buildVoiceControlSection(),
            const SizedBox(height: 16),
            _buildHighContrastSection(),
            const SizedBox(height: 16),
            _buildFontSizeSection(),
            const SizedBox(height: 16),
            _buildKeyboardNavigationSection(),
            const SizedBox(height: 16),
            _buildMotionReductionSection(),
            const SizedBox(height: 16),
            _buildFocusIndicatorsSection(),
            const SizedBox(height: 16),
            _buildLanguageSection(),
            const SizedBox(height: 16),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenReaderSection() {
    return Semantics(
      label: 'Screen Reader Einstellung',
      child: SwitchListTile(
        title: const Text('Screen Reader'),
        subtitle: const Text('Unterstützung für Screen Reader aktivieren'),
        value: _currentSettings.screenReaderEnabled,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    screenReaderEnabled: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.record_voice_over),
      ),
    );
  }

  Widget _buildVoiceControlSection() {
    return Semantics(
      label: 'Voice Control Einstellung',
      child: SwitchListTile(
        title: const Text('Voice Control'),
        subtitle: const Text('Sprachsteuerung aktivieren'),
        value: _currentSettings.voiceControlEnabled,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    voiceControlEnabled: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.mic),
      ),
    );
  }

  Widget _buildHighContrastSection() {
    return Semantics(
      label: 'High Contrast Mode Einstellung',
      child: SwitchListTile(
        title: const Text('High Contrast Mode'),
        subtitle: const Text('Erhöhter Kontrast für bessere Sichtbarkeit'),
        value: _currentSettings.highContrastEnabled,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    highContrastEnabled: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.contrast),
      ),
    );
  }

  Widget _buildFontSizeSection() {
    return Semantics(
      label: 'Schriftgröße Einstellung',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.text_fields),
              const SizedBox(width: 8),
              const Text('Schriftgröße'),
              const Spacer(),
              Text('${_currentSettings.fontSizeScale.toStringAsFixed(1)}x'),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: _currentSettings.fontSizeScale,
            min: 0.5,
            max: 3.0,
            divisions: 25,
            label: '${_currentSettings.fontSizeScale.toStringAsFixed(1)}x',
            onChanged: widget.isLoading
                ? null
                : (value) {
                    setState(() {
                      _currentSettings = _currentSettings.copyWith(
                        fontSizeScale: value,
                      );
                    });
                    _updateSettings();
                  },
          ),
          const Text(
            'Kleine Schrift (0.5x) - Große Schrift (3.0x)',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardNavigationSection() {
    return Semantics(
      label: 'Keyboard Navigation Einstellung',
      child: SwitchListTile(
        title: const Text('Keyboard Navigation'),
        subtitle: const Text('Vollständige Tastaturnavigation aktivieren'),
        value: _currentSettings.keyboardNavigationEnabled,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    keyboardNavigationEnabled: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.keyboard),
      ),
    );
  }

  Widget _buildMotionReductionSection() {
    return Semantics(
      label: 'Motion Reduction Einstellung',
      child: SwitchListTile(
        title: const Text('Motion Reduction'),
        subtitle: const Text('Bewegungen reduzieren für empfindliche Benutzer'),
        value: _currentSettings.reduceMotionEnabled,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    reduceMotionEnabled: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.motion_photos_pause),
      ),
    );
  }

  Widget _buildFocusIndicatorsSection() {
    return Semantics(
      label: 'Focus Indicators Einstellung',
      child: SwitchListTile(
        title: const Text('Focus Indicators'),
        subtitle: const Text('Focus-Indikatoren anzeigen'),
        value: _currentSettings.showFocusIndicators,
        onChanged: widget.isLoading
            ? null
            : (value) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(
                    showFocusIndicators: value,
                  );
                });
                _updateSettings();
              },
        secondary: const Icon(Icons.visibility),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Semantics(
      label: 'Sprache Einstellung',
      child: ListTile(
        leading: const Icon(Icons.language),
        title: const Text('Sprache'),
        subtitle: Text(_currentSettings.preferredLanguage),
        trailing: DropdownButton<String>(
          value: _currentSettings.preferredLanguage,
          onChanged: widget.isLoading
              ? null
              : (value) {
                  if (value != null) {
                    setState(() {
                      _currentSettings = _currentSettings.copyWith(
                        preferredLanguage: value,
                      );
                    });
                    _updateSettings();
                  }
                },
          items: const [
            DropdownMenuItem(value: 'de_DE', child: Text('Deutsch')),
            DropdownMenuItem(value: 'en_US', child: Text('English')),
            DropdownMenuItem(value: 'fr_FR', child: Text('Français')),
            DropdownMenuItem(value: 'es_ES', child: Text('Español')),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : _updateSettings,
        icon: const Icon(Icons.save),
        label: const Text('Einstellungen speichern'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
