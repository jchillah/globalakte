// shared/widgets/common_dialogs.dart
import 'package:flutter/material.dart';

import '../utils/navigation_utils.dart';

/// Gemeinsame Dialog-Widgets für bessere Wiederverwendbarkeit
/// Verbessert die Wartbarkeit durch zentrale Dialog-Komponenten
class CommonDialogs {
  /// Zeigt einen Bestätigungs-Dialog
  static Future<bool?> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Bestätigen',
    String cancelText = 'Abbrechen',
    bool isDestructive = false,
  }) {
    return NavigationUtils.showDialog<bool>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => NavigationUtils.goBack(context, true),
            style: isDestructive
                ? TextButton.styleFrom(foregroundColor: Colors.red)
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Informations-Dialog
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Fehler-Dialog
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Loading-Dialog
  static Future<void> showLoadingDialog(
    BuildContext context, {
    String message = 'Laden...',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(message),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Zeigt einen Details-Dialog
  static Future<void> showDetailsDialog(
    BuildContext context, {
    required String title,
    required Map<String, String> details,
    String buttonText = 'Schließen',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: details.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Formular-Dialog
  static Future<Map<String, String>?> showFormDialog(
    BuildContext context, {
    required String title,
    required List<FormField> fields,
    String confirmText = 'Speichern',
    String cancelText = 'Abbrechen',
  }) {
    final controllers = <String, TextEditingController>{};
    final formKey = GlobalKey<FormState>();

    for (final field in fields) {
      controllers[field.name] = TextEditingController(text: field.initialValue);
    }

    return NavigationUtils.showDialog<Map<String, String>>(
      context,
      AlertDialog(
        title: Text(title),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: fields.map((field) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: controllers[field.name],
                    decoration: InputDecoration(
                      labelText: field.label,
                      hintText: field.hint,
                    ),
                    keyboardType: field.keyboardType,
                    validator: field.validator,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final result = <String, String>{};
                for (final field in fields) {
                  result[field.name] = controllers[field.name]!.text;
                }
                NavigationUtils.goBack(context, result);
              }
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Auswahl-Dialog
  static Future<String?> showSelectionDialog(
    BuildContext context, {
    required String title,
    required String message,
    required List<String> options,
    String? cancelText,
  }) {
    return NavigationUtils.showDialog<String>(
      context,
      AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 16),
            ...options.map((option) => ListTile(
                  title: Text(option),
                  onTap: () => NavigationUtils.goBack(context, option),
                )),
          ],
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => NavigationUtils.goBack(context),
              child: Text(cancelText),
            ),
        ],
      ),
    );
  }

  /// Zeigt einen Datum-Auswahl-Dialog
  static Future<DateTime?> showDatePickerDialog(
    BuildContext context, {
    required String title,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return NavigationUtils.showDialog<DateTime>(
      context,
      AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 300,
          child: CalendarDatePicker(
            initialDate: initialDate ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(1900),
            lastDate: lastDate ?? DateTime(2100),
            onDateChanged: (date) => NavigationUtils.goBack(context, date),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Zeit-Auswahl-Dialog
  static Future<TimeOfDay?> showTimePickerDialog(
    BuildContext context, {
    required String title,
    TimeOfDay? initialTime,
  }) {
    return NavigationUtils.showDialog<TimeOfDay>(
      context,
      AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 300,
          child: TimePickerSpinner(
            time: initialTime ?? TimeOfDay.now(),
            is24HourMode: true,
            normalTextStyle: const TextStyle(fontSize: 24),
            highlightedTextStyle: const TextStyle(
              fontSize: 24,
              color: Colors.blue,
            ),
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) => NavigationUtils.goBack(context, time),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Erfolgs-Dialog
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Zeigt einen Warnung-Dialog
  static Future<void> showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return NavigationUtils.showDialog<void>(
      context,
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => NavigationUtils.goBack(context),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}

/// Formular-Feld-Definition
class FormField {
  final String name;
  final String label;
  final String? hint;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const FormField({
    required this.name,
    required this.label,
    this.hint,
    this.initialValue,
    this.keyboardType,
    this.validator,
  });
}

/// Einfacher Time Picker Spinner
class TimePickerSpinner extends StatefulWidget {
  final TimeOfDay time;
  final bool is24HourMode;
  final TextStyle? normalTextStyle;
  final TextStyle? highlightedTextStyle;
  final double spacing;
  final double itemHeight;
  final bool isForce2Digits;
  final Function(TimeOfDay) onTimeChange;

  const TimePickerSpinner({
    super.key,
    required this.time,
    this.is24HourMode = true,
    this.normalTextStyle,
    this.highlightedTextStyle,
    this.spacing = 50,
    this.itemHeight = 80,
    this.isForce2Digits = true,
    required this.onTimeChange,
  });

  @override
  State<TimePickerSpinner> createState() => _TimePickerSpinnerState();
}

class _TimePickerSpinnerState extends State<TimePickerSpinner> {
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _time = widget.time;
  }

  void _updateTime(int hour, int minute) {
    setState(() {
      _time = TimeOfDay(hour: hour, minute: minute);
    });
    widget.onTimeChange(_time);
  }

  String _formatNumber(int number) {
    if (widget.isForce2Digits) {
      return number.toString().padLeft(2, '0');
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stunden
        Column(
          children: [
            IconButton(
              onPressed: () {
                final newHour =
                    (_time.hour + 1) % (widget.is24HourMode ? 24 : 12);
                _updateTime(newHour, _time.minute);
              },
              icon: const Icon(Icons.keyboard_arrow_up),
            ),
            Text(
              _formatNumber(_time.hour),
              style: widget.highlightedTextStyle,
            ),
            IconButton(
              onPressed: () {
                final newHour =
                    (_time.hour - 1 + (widget.is24HourMode ? 24 : 12)) %
                        (widget.is24HourMode ? 24 : 12);
                _updateTime(newHour, _time.minute);
              },
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
        SizedBox(width: widget.spacing),
        // Minuten
        Column(
          children: [
            IconButton(
              onPressed: () {
                final newMinute = (_time.minute + 1) % 60;
                _updateTime(_time.hour, newMinute);
              },
              icon: const Icon(Icons.keyboard_arrow_up),
            ),
            Text(
              _formatNumber(_time.minute),
              style: widget.highlightedTextStyle,
            ),
            IconButton(
              onPressed: () {
                final newMinute = (_time.minute - 1 + 60) % 60;
                _updateTime(_time.hour, newMinute);
              },
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ],
        ),
      ],
    );
  }
}
