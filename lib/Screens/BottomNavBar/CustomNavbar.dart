import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final double height;
  final double imageSize;
  final double fontSize;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.height = 90.0,
    this.imageSize = 24.0,
    this.fontSize = 12.0,
  });

  final List<Map<String, String>> navItems = const [
    {
      'selected': ImageAssets.homeSelected,
      'unselected': ImageAssets.homeNotSelected,
      'label': 'Home'
    },
    {
      'selected': ImageAssets.categorySelected,
      'unselected': ImageAssets.categoryNotSelected,
      'label': 'Catalog'
    },
    {
      'selected': ImageAssets.cartSelected,
      'unselected': ImageAssets.cartNotSelected,
      'label': 'Cart'
    },
    {
      'selected': ImageAssets.profileSelected,
      'unselected': ImageAssets.profileNotSelected,
      'label': 'Profile'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 4.0),
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final isSelected = selectedIndex == index;
            return _buildNavItem(
              isSelected ? item['selected']! : item['unselected']!,
              item['label']!,
              index,
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(String imagePath, String label, int index) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onItemSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: isSelected ? imageSize + 6 : imageSize,
              height: isSelected ? imageSize + 6 : imageSize,
              child: Image.asset(imagePath),
            ),
            const SizedBox(height: 4.0),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: FFontStyles.subtitle(fontSize).copyWith(
                color: isSelected ? AppColors.primary : AppColors.navBarNotSelected,
              ),
              child: Text(label, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}

