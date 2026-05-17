import 'dart:async';
import 'package:flutter/material.dart';

class ResendTimerWidget extends StatefulWidget {
  final VoidCallback? onResend;

  const ResendTimerWidget({
    super.key,
    this.onResend,
  });

  @override
  State<ResendTimerWidget> createState() => _ResendTimerWidgetState();
}

class _ResendTimerWidgetState extends State<ResendTimerWidget> {
  Timer? _timer;
  int _seconds = 10;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    setState(() {
      _seconds = 10;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _seconds--;
        });
      }
    });
  }

  String get timerText {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  bool get showButton => _seconds == 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: showButton
          ? ElevatedButton(
        key: const ValueKey("button"),
        onPressed: () {
          widget.onResend?.call();
          startTimer();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text("إعادة إرسال"),
      ) : Text(
        key: const ValueKey("timer"),
        timerText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}