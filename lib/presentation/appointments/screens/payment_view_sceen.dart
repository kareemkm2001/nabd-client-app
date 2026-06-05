import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/widgets/app_app_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentViewScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymentViewScreen({
    super.key,
    required this.paymentUrl,
  });

  @override
  State<PaymentViewScreen> createState() => _PaymentViewScreenState();
}

class _PaymentViewScreenState extends State<PaymentViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            // نجاح الدفع
            if (url.contains("payment-success")) {
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }

            // فشل الدفع
            if (url.contains("payment-failed")) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.paymentUrl),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(titleKey: "Nabd App", isHome: true,),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}