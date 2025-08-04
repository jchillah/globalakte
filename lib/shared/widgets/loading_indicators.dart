// shared/widgets/loading_indicators.dart
import 'package:flutter/material.dart';

/// Loading-Indikatoren für bessere Wiederverwendbarkeit
/// Verbessert die Wartbarkeit durch zentrale Loading-Komponenten
class LoadingIndicators {
  /// Standard Loading-Indikator
  static Widget standard({
    String? message,
    Color? color,
    double size = 24.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color,
            strokeWidth: 2.0,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Linear Loading-Indikator
  static Widget linear({
    String? message,
    Color? color,
    double height = 4.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            color: color,
            minHeight: height,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Pulsierender Loading-Indikator
  static Widget pulsing({
    String? message,
    Color? color,
    double size = 48.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.5, end: 1.0),
            duration: const Duration(milliseconds: 1000),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: color ?? Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
            onEnd: () {
              // Animation wiederholen
            },
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Rotierender Loading-Indikator
  static Widget rotating({
    String? message,
    Color? color,
    double size = 32.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: AlwaysStoppedAnimation(0.0),
            child: Icon(
              Icons.refresh,
              size: size,
              color: color,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Skeleton Loading-Indikator
  static Widget skeleton({
    int itemCount = 3,
    double itemHeight = 20.0,
    double spacing = 8.0,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }

  /// Button Loading-Indikator
  static Widget button({
    String? text,
    Color? color,
    double size = 16.0,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color,
            strokeWidth: 2.0,
          ),
        ),
        if (text != null) ...[
          const SizedBox(width: 8),
          Text(text),
        ],
      ],
    );
  }

  /// Overlay Loading-Indikator
  static Widget overlay({
    String? message,
    Color? backgroundColor,
    Color? color,
  }) {
    return Container(
      color: backgroundColor ?? Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: color),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Progress Loading-Indikator
  static Widget progress({
    required double progress,
    String? message,
    Color? color,
    double height = 8.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: progress,
            color: color,
            minHeight: height,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Dots Loading-Indikator
  static Widget dots({
    String? message,
    Color? color,
    double size = 8.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 600 + (index * 200)),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: color ?? Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Wave Loading-Indikator
  static Widget wave({
    String? message,
    Color? color,
    double size = 20.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  builder: (context, value, child) {
                    return Container(
                      width: 4,
                      height: size * value,
                      decoration: BoxDecoration(
                        color: color ?? Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Spinner Loading-Indikator
  static Widget spinner({
    String? message,
    Color? color,
    double size = 32.0,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 3.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Minimal Loading-Indikator
  static Widget minimal({
    Color? color,
    double size = 16.0,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: 2.0,
      ),
    );
  }

  /// Fullscreen Loading-Indikator
  static Widget fullscreen({
    String? message,
    Color? backgroundColor,
    Color? color,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: color),
            if (message != null) ...[
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
