import 'package:flutter/material.dart';

class LanguageItem extends StatelessWidget {
  final String title;
  final Widget flag;
  final bool selected;
  final VoidCallback onTap;

  const LanguageItem({
    super.key,
    required this.title,
    required this.flag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: selected ? Colors.blue : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,

        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            flag,
            const SizedBox(width: 10),
          ],
        ),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),

        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selected ? Colors.blue : Colors.grey,
          ),
        ),

        onTap: onTap,
      ),
    );
  }
}