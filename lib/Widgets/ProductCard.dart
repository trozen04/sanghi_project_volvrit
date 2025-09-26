import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String stockLabel;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.stockLabel,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none, // allow Add button to overflow
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.details);
              },
              child: Container(
                height: height * 0.20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Stock badge
            Positioned(
              top: 18.0,
              left: 8.0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  stockLabel,
                  style: FFontStyles.link(10.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Add button half inside/outside image
            Positioned(
              bottom: -6.0,
              right: -2.0,
              child: GestureDetector(
                onTap: onAdd,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.primary),
                  ),
                  child: Text(
                    'Add',
                    style: FFontStyles.liveText(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.02), // space for button overflow

        // Product title
        Text(
          title,
          style: FFontStyles.titleText(14.0).copyWith(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
