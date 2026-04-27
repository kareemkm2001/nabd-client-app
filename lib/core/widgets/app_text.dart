import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';

class AppText extends StatelessWidget {
  final String jsonKey;
  final TextStyle textStyle ;

  const AppText({
    super.key,
    required this.jsonKey,
    required this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalization.t(jsonKey),
      style: textStyle
    );
  }
}