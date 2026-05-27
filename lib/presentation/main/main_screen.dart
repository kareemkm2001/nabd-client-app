import 'package:flutter/material.dart';
import 'package:nabd_client_app/core/theme/app_colors.dart';
import 'package:nabd_client_app/core/theme/app_text_styles.dart';
import 'package:nabd_client_app/core/widgets/app_text.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'home/screens/home_screen.dart';
import 'more/screens/more_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [

     HomeScreen(),

    const LikesScreen(),

    const SearchScreen(),

    MoreScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,

      body: AnimatedSwitcher(

        duration: const Duration(milliseconds: 400),

        transitionBuilder: (child, animation) {

          return FadeTransition(

            opacity: animation,

            child: SlideTransition(

              position: Tween<Offset>(

                begin: const Offset(0.1, 0),
                end: Offset.zero,

              ).animate(animation),

              child: child,
            ),
          );
        },

        child: screens[currentIndex],
      ),

      bottomNavigationBar: Container(

        margin: const EdgeInsets.only(bottom: 12,left: 12,right: 12),

        decoration: BoxDecoration(

          color: AppColors.surface,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [

            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(.08),
            ),

          ],
        ),

        child: SalomonBottomBar(

          currentIndex: currentIndex,

          onTap: (index) {

            setState(() {
              currentIndex = index;
            });

          },

          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),

          items: [

            SalomonBottomBarItem(

              icon: const Icon(Icons.home),

              title: AppText(
                jsonKey: "الرئيسية",
                textStyle: AppTextStyles.smallBoldPrimary,
              ),

              selectedColor: AppColors.primary,
            ),

            SalomonBottomBarItem(

              icon: const Icon(Icons.date_range_outlined),

              title: AppText(
                jsonKey: "المواعيد",
                textStyle: AppTextStyles.smallBoldSecondary,
              ),

              selectedColor: AppColors.secondary,
            ),

            SalomonBottomBarItem(

              icon: const Icon(Icons.receipt_long),

              title: AppText(
                jsonKey: "الطلبات",
                textStyle: AppTextStyles.smallBoldPremium,
              ),

              selectedColor: AppColors.premium,
            ),
            SalomonBottomBarItem(

              icon: const Icon(Icons.menu),

              title: AppText(
                jsonKey: "المزيد",
                textStyle: AppTextStyles.smallBoldWarning,
              ),
              selectedColor: AppColors.warning,
            ),

          ],
        ),
      ),
    );
  }
}









class LikesScreen extends StatelessWidget {
  const LikesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: Text(

          "Likes Screen",

          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}









class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      body: Center(

        child: Text(

          "Search Screen",

          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}








