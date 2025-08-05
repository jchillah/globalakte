// core/performance_monitor.dart

import 'dart:async';
import 'dart:developer' as developer;

/// Erweiterte Performance Monitoring Klasse
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<Duration>> _measurements = {};
  final Map<String, int> _errorCounts = {};
  final Map<String, int> _successCounts = {};
  final List<PerformanceEvent> _events = [];

  /// Timer starten
  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
    _logEvent('TIMER_START', name);
  }

  /// Timer stoppen und Messung speichern
  Duration stopTimer(String name) {
    final timer = _timers[name];
    if (timer == null) return Duration.zero;

    timer.stop();
    final duration = timer.elapsed;
    
    _measurements.putIfAbsent(name, () => []).add(duration);
    _logEvent('TIMER_STOP', name, {'duration': duration.inMilliseconds});
    
    _timers.remove(name);
    return duration;
  }

  /// Performance-Messung durchführen
  Future<T> measureAsync<T>(String name, Future<T> Function() operation) async {
    startTimer(name);
    try {
      final result = await operation();
      _successCounts[name] = (_successCounts[name] ?? 0) + 1;
      return result;
    } catch (e) {
      _errorCounts[name] = (_errorCounts[name] ?? 0) + 1;
      _logEvent('ERROR', name, {'error': e.toString()});
      rethrow;
    } finally {
      stopTimer(name);
    }
  }

  /// Synchronous Performance-Messung
  T measureSync<T>(String name, T Function() operation) {
    startTimer(name);
    try {
      final result = operation();
      _successCounts[name] = (_successCounts[name] ?? 0) + 1;
      return result;
    } catch (e) {
      _errorCounts[name] = (_errorCounts[name] ?? 0) + 1;
      _logEvent('ERROR', name, {'error': e.toString()});
      rethrow;
    } finally {
      stopTimer(name);
    }
  }

  /// Memory Usage überwachen
  void trackMemoryUsage(String context) {
    final memoryInfo = _getMemoryInfo();
    _logEvent('MEMORY_USAGE', context, memoryInfo);
  }

  /// Network Performance überwachen
  void trackNetworkCall(String endpoint, Duration duration, {bool success = true}) {
    _logEvent('NETWORK_CALL', endpoint, {
      'duration': duration.inMilliseconds,
      'success': success,
    });
  }

  /// UI Performance überwachen
  void trackUIRender(String widgetName, Duration renderTime) {
    _logEvent('UI_RENDER', widgetName, {
      'renderTime': renderTime.inMilliseconds,
    });
  }

  /// Error Tracking
  void trackError(String context, dynamic error, [StackTrace? stackTrace]) {
    _errorCounts[context] = (_errorCounts[context] ?? 0) + 1;
    _logEvent('ERROR', context, {
      'error': error.toString(),
      'stackTrace': stackTrace?.toString(),
    });
  }

  /// Success Tracking
  void trackSuccess(String context) {
    _successCounts[context] = (_successCounts[context] ?? 0) + 1;
    _logEvent('SUCCESS', context);
  }

  /// Performance-Statistiken abrufen
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{};
    
    // Timer-Statistiken
    for (final entry in _measurements.entries) {
      final measurements = entry.value;
      if (measurements.isNotEmpty) {
        final avg = measurements.map((d) => d.inMilliseconds).reduce((a, b) => a + b) / measurements.length;
        final min = measurements.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b);
        final max = measurements.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b);
        
        stats[entry.key] = {
          'count': measurements.length,
          'average_ms': avg,
          'min_ms': min,
          'max_ms': max,
          'total_ms': measurements.map((d) => d.inMilliseconds).reduce((a, b) => a + b),
        };
      }
    }

    // Error/Success Statistiken
    stats['errors'] = _errorCounts;
    stats['successes'] = _successCounts;

    // Event Statistiken
    stats['total_events'] = _events.length;
    stats['recent_events'] = _events.take(10).map((e) => e.toMap()).toList();

    return stats;
  }

  /// Performance-Report generieren
  String generateReport() {
    final stats = getStatistics();
    final report = StringBuffer();
    
    report.writeln('=== Performance Report ===');
    report.writeln('Generated: ${DateTime.now()}');
    report.writeln();

    // Timer-Statistiken
    report.writeln('Timer Statistics:');
    for (final entry in stats.entries) {
      if (entry.key != 'errors' && entry.key != 'successes' && entry.key != 'total_events' && entry.key != 'recent_events') {
        final data = entry.value as Map<String, dynamic>;
        report.writeln('  ${entry.key}:');
        report.writeln('    Count: ${data['count']}');
        report.writeln('    Average: ${data['average_ms'].toStringAsFixed(2)}ms');
        report.writeln('    Min: ${data['min_ms']}ms');
        report.writeln('    Max: ${data['max_ms']}ms');
        report.writeln('    Total: ${data['total_ms']}ms');
        report.writeln();
      }
    }

    // Error/Success Statistiken
    report.writeln('Error Counts:');
    for (final entry in _errorCounts.entries) {
      report.writeln('  ${entry.key}: ${entry.value}');
    }
    report.writeln();

    report.writeln('Success Counts:');
    for (final entry in _successCounts.entries) {
      report.writeln('  ${entry.key}: ${entry.value}');
    }
    report.writeln();

    return report.toString();
  }

  /// Performance-Daten zurücksetzen
  void reset() {
    _timers.clear();
    _measurements.clear();
    _errorCounts.clear();
    _successCounts.clear();
    _events.clear();
  }

  /// Event loggen
  void _logEvent(String type, String name, [Map<String, dynamic>? data]) {
    final event = PerformanceEvent(
      type: type,
      name: name,
      timestamp: DateTime.now(),
      data: data ?? {},
    );
    _events.add(event);
    
    // Log für Debugging
    developer.log('Performance: $type - $name', name: 'PerformanceMonitor');
  }

  /// Memory Info simulieren
  Map<String, dynamic> _getMemoryInfo() {
    // In einer echten Implementierung würde hier echte Memory-Info abgerufen
    return {
      'heap_size': '~50MB',
      'external_size': '~10MB',
      'rss': '~100MB',
    };
  }
}

/// Performance Event
class PerformanceEvent {
  final String type;
  final String name;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  const PerformanceEvent({
    required this.type,
    required this.name,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
    };
  }

  @override
  String toString() {
    return 'PerformanceEvent(type: $type, name: $name, timestamp: $timestamp)';
  }
}

/// Performance Monitoring Mixin
mixin PerformanceMonitoring {
  PerformanceMonitor get _monitor => PerformanceMonitor();

  /// Async Operation mit Performance-Tracking
  Future<T> trackAsync<T>(String name, Future<T> Function() operation) {
    return _monitor.measureAsync(name, operation);
  }

  /// Sync Operation mit Performance-Tracking
  T trackSync<T>(String name, T Function() operation) {
    return _monitor.measureSync(name, operation);
  }

  /// Error Tracking
  void trackError(String context, dynamic error, [StackTrace? stackTrace]) {
    _monitor.trackError(context, error, stackTrace);
  }

  /// Success Tracking
  void trackSuccess(String context) {
    _monitor.trackSuccess(context);
  }

  /// UI Render Tracking
  void trackUIRender(String widgetName, Duration renderTime) {
    _monitor.trackUIRender(widgetName, renderTime);
  }
} 