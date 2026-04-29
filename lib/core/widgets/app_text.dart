import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/localization/app_localization.dart';

class AppText extends StatelessWidget {
  final String jsonKey;
  final TextStyle? textStyle ;
  final TextAlign textAlign ;
  final double margin ;

   const AppText({
    super.key,
    required this.jsonKey,
     this.textStyle,
    this.textAlign = TextAlign.start,
    this.margin = 0
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: margin),
      child: Text(
        AppLocalization.t(jsonKey),
        style: textStyle,
        textAlign: textAlign,
      ),
    );
  }
}