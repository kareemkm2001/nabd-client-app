import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';

import '../localization/app_localization.dart';
import '../services/token_service.dart';
import 'app_route_animation.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/splash/splash_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeader(context),
              _animatedItem(
                icon: Icons.timer_off_rounded,
                title: AppLocalization.t('المواعيد'),
                onTap: () {

                },
              ),
              _animatedItem(
                icon: Icons.request_page_rounded,
                title: AppLocalization.t('طلبات المواعيد'),
                onTap: () {

                },
              ),
              _animatedItem(
                icon: Icons.request_page_rounded,
                title: AppLocalization.t('الفواتير'),
                onTap: () {

                },
              ),
              _animatedItem(
                icon: Icons.settings,
                title: AppLocalization.t('settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              Spacer(),
              _animatedItem(
                icon: Icons.logout,
                title: AppLocalization.t('logout'),
                onTap: () async {
                  await TokenService.clearToken();

                  Navigator.pop(context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    AppRouteAnimation(
                      page: const SplashScreen(),
                    ),
                        (_) => false,
                  );
                },
              ),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          AppLocalization.t('app_name'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------------- ITEM ----------------
  Widget _animatedItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                        icon,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: AppTextStyles.mediumBlack,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}