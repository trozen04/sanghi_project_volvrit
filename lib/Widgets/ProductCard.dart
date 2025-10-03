import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String imagePath;
  final String stockLabel;
  final num cartQuantity;
  final VoidCallback onAdd;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.imagePath,
    required this.stockLabel,
    required this.cartQuantity,
    required this.onAdd,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    String cleanUrl = imagePath.replaceAll('\\', '/').replaceAll(' ', '%20');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.details, arguments: id);
              },
              child: Container(
                height: height * 0.20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image loaded
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.shade300, // shimmer background or static grey
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Image failed to load
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.shade200, // subtle grey box
                        child: const Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),

                ),
              ),
            ),

            // Stock badge
            Positioned(
              top: 18.0,
              left: 8.0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
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

            // Add button or quantity counter
            Positioned(
              bottom: -8.0,
              right: -2.0,
              child: cartQuantity == 0
                  ? GestureDetector(
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
              )
                  : Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onDecrement,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text('-', style: FFontStyles.liveText(16.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Text(cartQuantity.toString(), style: FFontStyles.liveText(14.0)),
                    ),
                    GestureDetector(
                      onTap: onIncrement,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: Text('+', style: FFontStyles.liveText(16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.02),

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
