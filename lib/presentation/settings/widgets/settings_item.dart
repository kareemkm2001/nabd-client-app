import 'package:flutter/material.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  final bool isSwitch;
  final bool switchValue;
  final Function(bool)? onSwitchChanged;

  final VoidCallback? onTap;

  final String? heroTag;

  const SettingsItem({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.isSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
    this.onTap,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: heroTag != null
            ? Hero(
          tag: heroTag!,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
            child: Icon(icon, color: color),
          ),
        )
            : Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.15),
          ),
          child: Icon(icon, color: color),
        ),

        title: Text(title),

        trailing: isSwitch
            ? Switch(
          value: switchValue,
          onChanged: onSwitchChanged,

          activeColor: Colors.white,
          activeTrackColor: Colors.green,

          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        )
            : const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: isSwitch ? null : onTap,
      ),
    );
  }
}