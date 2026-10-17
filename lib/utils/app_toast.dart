import 'dart:async';

import 'package:flutter/material.dart';

class AppToast {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(BuildContext context, String message) {
    _timer?.cancel();
    _entry?.remove();

    final overlay = Overlay.of(context, rootOverlay: true);
    final bottomOffset = MediaQuery.paddingOf(context).bottom + 88;
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        bottom: bottomOffset,
        child: IgnorePointer(
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xE61A1722),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0x668B3DFF)),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    _entry = entry;
    overlay.insert(entry);
    _timer = Timer(const Duration(seconds: 2), () {
      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }
}
