import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';

class AppAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? titleKey;
  final Widget? trailing;
  final VoidCallback? onTrailingPressed;

  const AppAppBar({
    super.key,
    this.titleKey,
    this.trailing,
    this.onTrailingPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,

        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),

        middle: titleKey != null
            ? Text(
          titleKey!,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        )
            : null,

        trailing: trailing != null
            ? GestureDetector(
          onTap: onTrailingPressed,
          child: trailing,
        )
            : null,
      );
    }

    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,

      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
      ),

      title: titleKey != null
          ? Text(
        titleKey!,
        style: const TextStyle(color: Colors.black),
      )
          : null,

      actions: trailing != null
          ? [
        IconButton(
          onPressed: onTrailingPressed,
          icon: trailing!,
          color: Colors.black,
        ),
      ]
          : null,
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}