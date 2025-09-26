import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap; // optional custom onTap

  const CustomAppBar({
    required this.title,
    this.actions,
    this.onLeadingTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width * 0.04;

    return AppBar(
      backgroundColor: AppColors.background,
      leadingWidth: width * 0.13,
      leading: Padding(
        padding: EdgeInsets.only(left: horizontalPadding),
        child: GestureDetector(
          onTap: onLeadingTap ?? () => Navigator.pop(context), // default or custom
          child: Image.asset(ImageAssets.leadingArrow),
        ),
      ),
      title: Text(
        title,
        style: FFontStyles.customAppBarTitleText(22),
      ),
      actions: actions?.map((a) => Padding(
        padding: EdgeInsets.only(right: horizontalPadding),
        child: a,
      )).toList(),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
