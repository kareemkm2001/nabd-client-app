import 'package:flutter/material.dart';

class AvatarHelper {
  static Widget getAvatar(String firstName, String lastName) {
    final String initials =
        "${_getInitial(firstName)} ${_getInitial(lastName)}";

    return CircleAvatar(
      radius: 35,
      backgroundColor: Colors.blueAccent,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  static String _getInitial(String name) {
    if (name.trim().isEmpty) return "";
    return name.trim().characters.first;
  }
}