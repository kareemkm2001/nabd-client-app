import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_button.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import '../auth/screens/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      img: "assets/icons/leaf.svg",
      titleKey: 'onboarding_title_1',
      descriptionKey: 'onboarding_desc_1',
    ),
    _OnboardingData(
      img: "assets/icons/doctors.svg",
      titleKey: 'onboarding_title_2',
      descriptionKey: 'onboarding_desc_2',
    ),
    _OnboardingData(
      img: "assets/icons/calendar.svg",
      titleKey: 'onboarding_title_3',
      descriptionKey: 'onboarding_desc_3',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _goToLogin,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary
              ),
              child: AppText(
                  jsonKey: "skip",
                  textStyle: AppTextStyles.mediumGrey,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 72,
                        backgroundColor: AppColors.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: SvgPicture.asset(
                              page.img,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 42),
                      AppText(
                          jsonKey: page.titleKey,
                          textStyle: AppTextStyles.displayMediumBlack,
                        margin: 16,
                      ),
                      const SizedBox(height: 24),
                      AppText(
                          jsonKey: page.descriptionKey,
                          textStyle: AppTextStyles.mediumGrey,
                        textAlign: TextAlign.center,
                        margin: 24,
                      ),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                  titleKey: isLastPage ?"get_started" : "next",
                  margin: 38,
                  onTap: (){
                    if (isLastPage) {
                      _goToLogin();
                      return;
                    }
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  }
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String img;
  final String titleKey;
  final String descriptionKey;

  const _OnboardingData({
    required this.img,
    required this.titleKey,
    required this.descriptionKey,
  });
}
