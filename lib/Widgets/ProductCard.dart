
import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String? imagePath;
  final int stockLabel;
  final num cartQuantity;
  final VoidCallback onAdd;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onViewCart;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    this.imagePath,
    required this.stockLabel,
    required this.cartQuantity,
    required this.onAdd,
    this.onIncrement,
    this.onDecrement,
    this.onViewCart,
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
                  border: Border.all(
                    color: AppColors.primary
                  )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    imagePath!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child; // Image loaded
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.shade300,
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
            // Positioned(
            //   top: 18.0,
            //   left: 8.0,
            //   child: Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
            //     decoration: BoxDecoration(
            //       color: AppColors.background,
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: Text(
            //       '$stockLabel Stock Left',
            //       style: FFontStyles.link(10.0),
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ),
            // ),

            Positioned(
              bottom: -8.0,
              right: -2.0,
              child: GestureDetector(
                onTap: onAdd,
                child: AnimatedScale(
                  scale: cartQuantity > 0 ? 1.0 : 1.0, // you can animate on tap
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  child: Material(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: cartQuantity == 0 ? onAdd : onViewCart,
                      borderRadius: BorderRadius.circular(8),
                      splashColor: AppColors.primary.withOpacity(0.3),
                      highlightColor: AppColors.primary.withOpacity(0.1),
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
                        alignment: Alignment.center,
                        child: Text(
                          cartQuantity == 0 ? 'Add' : 'View Cart',
                          style: FFontStyles.liveText(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )

            // Positioned(
            //   bottom: -8.0,
            //   right: -2.0,
            //   child: cartQuantity == 0
            //       ? GestureDetector(
            //     onTap: onAdd,
            //     child: Container(
            //       padding: EdgeInsets.symmetric(
            //         horizontal: width * 0.05,
            //         vertical: height * 0.008,
            //       ),
            //       decoration: BoxDecoration(
            //         color: AppColors.background,
            //         borderRadius: BorderRadius.circular(8.0),
            //         border: Border.all(color: AppColors.primary),
            //       ),
            //       child: Text(
            //         'Add',
            //         style: FFontStyles.liveText(12.0),
            //       ),
            //     ),
            //   )
            //       : Container(
            //     decoration: BoxDecoration(
            //       color: AppColors.background,
            //       borderRadius: BorderRadius.circular(8.0),
            //       border: Border.all(color: AppColors.primary),
            //     ),
            //     child: Row(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         // Decrement button
            //         Material(
            //           color: Colors.transparent, // transparent so the container color shows
            //           borderRadius: BorderRadius.circular(8),
            //           child: InkWell(
            //             onTap: onDecrement,
            //             borderRadius: BorderRadius.circular(8),
            //             splashColor: AppColors.primary.withOpacity(0.3),
            //             child: Container(
            //               width: 40,
            //               height: 40,
            //               alignment: Alignment.center,
            //               child: Text('-', style: FFontStyles.liveText(18.0)),
            //             ),
            //           ),
            //         ),
            //
            //         // Quantity display
            //         Container(
            //           width: 40,
            //           height: 40,
            //           alignment: Alignment.center,
            //           child: Text(cartQuantity.toString(), style: FFontStyles.liveText(16.0)),
            //         ),
            //
            //         // Increment button
            //         Material(
            //           color: Colors.transparent,
            //           borderRadius: BorderRadius.circular(8),
            //           child: InkWell(
            //             onTap: onIncrement,
            //             borderRadius: BorderRadius.circular(8),
            //             splashColor: AppColors.primary.withOpacity(0.3),
            //             child: Container(
            //               width: 40,
            //               height: 40,
            //               alignment: Alignment.center,
            //               child: Text('+', style: FFontStyles.liveText(18.0)),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            //
            //
            // ),
          ],
        ),

        SizedBox(height: height * 0.02),

        // Product title
        Text(
          title,
          style: FFontStyles.customAppBarTitleText(14.0),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
