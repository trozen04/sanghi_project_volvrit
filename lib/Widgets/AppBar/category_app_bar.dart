import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Screens/HomeScreens/Catalog/CategorySearchPage.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppGraidients.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showCenterText;
  final String? centerText;
  final Function(String)? onSearchSubmitted; // <-- callback

  const CategoryAppBar({
    super.key,
    this.showCenterText = false,
    this.centerText,
    this.onSearchSubmitted,

  });

  @override
  Size get preferredSize => const Size.fromHeight(150.0);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.2,
      decoration: BoxDecoration(
        gradient: AppGradients.topToBottom,
        image: DecorationImage(
          image: AssetImage(ImageAssets.LoginBG),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.01,
      ),
      child: showCenterText
          ? Center(
        child: Text(
          centerText ?? '',
          style: FFontStyles.titleText(22).copyWith(color: AppColors.background)
        ),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(ImageAssets.appLogo, height: height * 0.07),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.notificationPage),
                child: Image.asset(
                  ImageAssets.notificationIcon,
                  width: width * 0.1,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(width: 12),
              _circleIcon(Icons.search_rounded, width, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, double width, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategorySearchPage()),
        );

        if (result != null && result is String) {
          print('User searched for: $result');

          // <-- Call the callback here so CategoryScreen gets the query
          if (onSearchSubmitted != null) {
            onSearchSubmitted!(result);
          }
        }
      },
      child: Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.background, width: 1.5),
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon, color: AppColors.background, size: width * 0.06),
      ),
    );
  }

}
