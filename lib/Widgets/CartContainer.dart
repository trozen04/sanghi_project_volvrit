import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:shimmer/shimmer.dart';

class CartContainer extends StatelessWidget {
  final double width;
  final double height;
  final String imagePath;
  final String title;
  final String purity;
  final String weight;
  final VoidCallback? onDelete;

  const CartContainer({
    super.key,
    required this.width,
    required this.height,
    required this.imagePath,
    required this.title,
    required this.purity,
    required this.weight,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.015,
        ),
        margin: EdgeInsets.only(bottom: height * 0.02),
        decoration: BoxDecoration(
          color: AppColors.cartContainerColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cartContainerBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Product Image
            Container(
              height: height * 0.1,
              width: width * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    // shimmer while loading
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    // subtle placeholder if image fails
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: width * 0.04),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: FFontStyles.cartTitle(16), overflow: TextOverflow.ellipsis),
                  CartInfoRow(label: 'Purity', value: purity),
                  CartInfoRow(label: 'Weight', value: weight ?? ''),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),

            // Delete Icon
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: Image.asset(ImageAssets.deleteIcon, width: width * 0.06),
              ),
          ],
        ),
      ),
    );
  }
}