import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String? titleKey;
  final Widget? trailing;
  final VoidCallback? onTrailingPressed;
  final bool isHome;

  const AppAppBar({
    super.key,
    this.titleKey,
    this.trailing,
    this.onTrailingPressed,
    this.isHome = false,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: null,
        leading: isHome
            ? null
            : GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        middle: titleKey != null
            ? Text(
          titleKey!,
          textAlign: TextAlign.center,
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
      scrolledUnderElevation: 0,
      centerTitle: isHome,
      leading: isHome
          ? null
          : IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        color: Colors.black,
      ),

      title: titleKey != null
          ? AppText(
            jsonKey: titleKey!,
            textStyle: AppTextStyles.largeBoldPrimary,

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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}