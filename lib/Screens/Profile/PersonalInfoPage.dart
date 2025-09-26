import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';

class PersonalInfoPage extends StatelessWidget {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    // Dummy data (replace with actual data)
    final userData = {
      'Name': 'John Doe',
      'Phone Number': '+91 9876543210',
      'Business Name': 'Doe Enterprises',
      'GST Number': '27ABCDE1234F1Z5',
      'Business Address': '123, Business Street, City',
      'Email': 'john.doe@example.com',
    };

    return Scaffold(
      appBar: CustomAppBar(title: 'Personal Info'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: isLoading
            ? PersonalInfoPageShimmer()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // List of info rows
            ...userData.keys.map((key) {
              final value = userData[key]!;
              return InfoRowWidget(label: key, value: value);
            }).toList(),

            SizedBox(height: height * 0.04),

            // Edit Profile button right after the last row
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editProfilePage);
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImageAssets.editProfile,
                      height: height * 0.025,
                      width: height * 0.025,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      'Edit Profile',
                      style: FFontStyles.quantity(16)?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.background, // optional, if you have custom bg
    );
  }
}
