import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nabd_client_app/core/services/token_service.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_route_animation.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:nabd_client_app/presentation/home/screens/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _scaleController;
  late AnimationController _rotateController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 8, end: 1).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
    );


    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotateController,
        curve: Curves.easeOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      _scaleController.forward().then((_) {
        _rotateController.forward();
      });
    });

    Timer(const Duration(milliseconds: 3500), () async {
      if (!mounted) return;

      final token = await TokenService.getToken();
      Navigator.of(context).pushReplacement(AppRouteAnimation(page: token == null ? OnboardingScreen() : HomeScreen()));
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _scaleController,
                _rotateController,
              ]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Transform.rotate(
                    angle: _rotationAnimation.value * 6.28,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(70.0),
                child: SvgPicture.asset(
                  'assets/logo/nabd_logo.svg',
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: AppText(
                jsonKey: 'developed_operated_nwit',
                textStyle: AppTextStyles.mediumBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}