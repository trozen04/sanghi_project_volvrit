import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/CartContainer.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';

class CartPage extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const CartPage({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    bool isLoading = false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Cart',
        onLeadingTap: onBackToHome ?? () => Navigator.pop(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: isLoading
            ? CartPageShimmer()
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return CartContainer(
                    width: width,
                    height: height,
                    imagePath: ImageAssets.RingImage,
                    title: 'Regal Floral Gold Ring',
                    purity: '22 carat',
                    weight: '2.4 g',
                    onDelete: () {
                      // handle delete action
                    },
                  );
                },
              ),
            ),
            StaggeredReveal(
              initialDelay: const Duration(milliseconds: 80),
              duration: const Duration(milliseconds: 900),
              staggerFraction: 0.18,
              children: [
                Text('Total', style: FFontStyles.customAppBarTitleText(20)),
                SizedBox(height: height * 0.01),
                cartPageRow(label: 'Quantity -', value: '02'),
                SizedBox(height: height * 0.01),
                cartPageRow(label: 'Total Weight -', value: '12.3 g'),
                SizedBox(height: height * 0.02),
                ReusableButton(
                  text: 'Submit',
                  onPressed: () {},
                  color: AppColors.primary,
                  width: width,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}