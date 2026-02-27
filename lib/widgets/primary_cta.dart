import 'package:flutter/material.dart';

class PrimaryCta extends StatelessWidget {
  const PrimaryCta({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        child: Text(label),
      ),
    );
  }
}
