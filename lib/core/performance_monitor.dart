// core/performance_monitor.dart
import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Performance Monitor für GlobalAkte
/// Überwacht App-Performance und sammelt Metriken
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<double>> _metrics = {};
  final List<PerformanceEvent> _events = [];
  bool _isEnabled = true;

  /// Performance-Monitoring aktivieren/deaktivieren
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (kDebugMode) {
      developer.log('Performance Monitor ${enabled ? 'aktiviert' : 'deaktiviert'}');
    }
  }

  /// Timer für Operation starten
  void startTimer(String operation) {
    if (!_isEnabled) return;
    
    _timers[operation] = Stopwatch()..start();
    if (kDebugMode) {
      developer.log('Timer gestartet: $operation');
    }
  }

  /// Timer stoppen und Metrik speichern
  void stopTimer(String operation) {
    if (!_isEnabled) return;
    
    final timer = _timers[operation];
    if (timer != null) {
      timer.stop();
      final duration = timer.elapsedMicroseconds / 1000.0; // in Millisekunden
      
      _metrics.putIfAbsent(operation, () => []).add(duration);
      _events.add(PerformanceEvent(
        operation: operation,
        duration: duration,
        timestamp: DateTime.now(),
      ));
      
      _timers.remove(operation);
      
      if (kDebugMode) {
        developer.log('Timer gestoppt: $operation (${duration.toStringAsFixed(2)}ms)');
      }
    }
  }

  /// Memory-Usage messen
  void recordMemoryUsage(String context) {
    if (!_isEnabled) return;
    
    // In einer echten App würden wir hier echte Memory-Metriken sammeln
    final memoryUsage = _simulateMemoryUsage();
    
    _events.add(PerformanceEvent(
      operation: 'memory_usage',
      duration: memoryUsage,
      timestamp: DateTime.now(),
      metadata: {'context': context},
    ));
    
    if (kDebugMode) {
      developer.log('Memory Usage ($context): ${memoryUsage.toStringAsFixed(2)}MB');
    }
  }

  /// Frame-Rate messen
  void recordFrameRate(double fps) {
    if (!_isEnabled) return;
    
    _events.add(PerformanceEvent(
      operation: 'frame_rate',
      duration: fps,
      timestamp: DateTime.now(),
    ));
    
    if (kDebugMode && fps < 30) {
      developer.log('WARNUNG: Niedrige Frame-Rate: ${fps.toStringAsFixed(1)} FPS');
    }
  }

  /// Performance-Report generieren
  Map<String, dynamic> generateReport() {
    final report = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'total_events': _events.length,
      'metrics': <String, dynamic>{},
      'warnings': <String>[],
    };

    // Durchschnittliche Dauer für jede Operation berechnen
    for (final entry in _metrics.entries) {
      final operation = entry.key;
      final durations = entry.value;
      
      if (durations.isNotEmpty) {
        final avgDuration = durations.reduce((a, b) => a + b) / durations.length;
        final maxDuration = durations.reduce((a, b) => a > b ? a : b);
        final minDuration = durations.reduce((a, b) => a < b ? a : b);
        
        report['metrics'][operation] = {
          'count': durations.length,
          'avg_duration_ms': avgDuration,
          'max_duration_ms': maxDuration,
          'min_duration_ms': minDuration,
        };

        // Warnungen für langsame Operationen
        if (avgDuration > 1000) { // > 1 Sekunde
          report['warnings'].add('Langsame Operation: $operation (${avgDuration.toStringAsFixed(2)}ms)');
        }
      }
    }

    // Frame-Rate Analyse
    final frameRateEvents = _events.where((e) => e.operation == 'frame_rate').toList();
    if (frameRateEvents.isNotEmpty) {
      final avgFps = frameRateEvents.map((e) => e.duration).reduce((a, b) => a + b) / frameRateEvents.length;
      report['metrics']['frame_rate'] = {
        'avg_fps': avgFps,
        'count': frameRateEvents.length,
      };
      
      if (avgFps < 30) {
        report['warnings'].add('Niedrige durchschnittliche Frame-Rate: ${avgFps.toStringAsFixed(1)} FPS');
      }
    }

    return report;
  }

  /// Performance-Daten zurücksetzen
  void reset() {
    _timers.clear();
    _metrics.clear();
    _events.clear();
    
    if (kDebugMode) {
      developer.log('Performance Monitor zurückgesetzt');
    }
  }

  /// Aktive Timer anzeigen
  List<String> get activeTimers => _timers.keys.toList();

  /// Letzte Events abrufen
  List<PerformanceEvent> get recentEvents => _events.take(100).toList();

  /// Simulierte Memory-Usage (für Demo-Zwecke)
  double _simulateMemoryUsage() {
    // Simuliere Memory-Usage zwischen 50-200 MB
    return 50 + (DateTime.now().millisecondsSinceEpoch % 150);
  }
}

/// Performance-Event für detaillierte Analyse
class PerformanceEvent {
  final String operation;
  final double duration;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  PerformanceEvent({
    required this.operation,
    required this.duration,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

/// Performance-Utilities für einfache Verwendung
class PerformanceUtils {
  /// Operation mit Timer ausführen
  static Future<T> measureOperation<T>(
    String operation,
    Future<T> Function() callback,
  ) async {
    PerformanceMonitor().startTimer(operation);
    try {
      final result = await callback();
      return result;
    } finally {
      PerformanceMonitor().stopTimer(operation);
    }
  }

  /// Widget-Performance messen
  static void measureWidgetBuild(String widgetName) {
    PerformanceMonitor().startTimer('widget_build_$widgetName');
  }

  static void endWidgetBuild(String widgetName) {
    PerformanceMonitor().stopTimer('widget_build_$widgetName');
  }
} 