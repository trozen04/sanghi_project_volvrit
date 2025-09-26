import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/CustomConfirmationDialog.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:gold_project/Widgets/AppBar/category_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      appBar: CategoryAppBar(showCenterText: true, centerText: 'Profile',),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              children: [
                Text(
                  'Rohit sharma',
                  style: FFontStyles.titleText(22),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'rohitsharma12@gmail.com',
                  style: FFontStyles.cartLabel(16),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: ListView(
                children: [
                  ProfileCard(
                    imagePath: ImageAssets.user,
                    title: 'Personal info',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.personalInfoPage),
                  ),
                  ProfileCard(
                    imagePath: ImageAssets.myOrders,
                    title: 'My Orders',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.orderPage),
                  ),
                  ProfileCard(
                    imagePath: ImageAssets.passWord,
                    title: 'Change Password',
                    onTap: () {},
                  ),
                  ProfileCard(
                    imagePath: ImageAssets.support,
                    title: 'Support',
                    onTap: () {},
                  ),
                  ProfileCard(
                    imagePath: ImageAssets.logout,
                    title: 'Logout',
                    iconColor: AppColors.logoutColor,
                    onTap: () async {
                      // Show the confirmation dialog
                      bool confirm = await CustomConfirmationDialog.show(
                        context: context,
                        title: "Logout",
                        description: "Are you sure you want to logout?",
                        confirmText: "Logout",
                        cancelText: "Cancel",
                        confirmColor: AppColors.logoutColor, // optional
                      );

                      // Handle user response
                      if (confirm) {
                        // User confirmed
                        await Prefs.clearPrefs(); // clear shared preferences
                        // Navigate to login screen or another screen
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    },
                  ),

                ],
              )
            ),
          ),
        ],
      ),
    );
  }
}