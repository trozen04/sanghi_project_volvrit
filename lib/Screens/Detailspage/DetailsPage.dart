import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});


  @override
  _DetailsPageState createState() => _DetailsPageState();
}


class _DetailsPageState extends State<DetailsPage> {
  int _quantity = 0;
  String _currentImage = ImageAssets.ringDetails; // Default main image
  bool isLoading = false;
  void _addToCart() {
    setState(() {
      _quantity = 1;
    });
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 0) _quantity--;
    });
  }

  void _changeMainImage(String newImage) {
    setState(() {
      _currentImage = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    final additionalImages = [
      ImageAssets.ringDetails,
      ImageAssets.ringImage1,
      ImageAssets.ringImage2
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Details'),
      body: isLoading
          ? DetailsPageShimmer()
          : SingleChildScrollView(
        child: StaggeredReveal(
          initialDelay: const Duration(milliseconds: 80),
          duration: const Duration(milliseconds: 900),
          staggerFraction: 0.18,
          children: [
            // Image Stack Widget
            ImageStackWidget(
              currentImage: _currentImage,
              additionalImages: additionalImages,
              height: height,
              width: width,
              onImageTap: _changeMainImage,
            ),
            // Product Details
            Padding(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Regal Floral Gold Ring',
                        style: FFontStyles.customAppBarTitleText(20),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.005),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '2 Stock Left',
                          style: FFontStyles.stockLeft(14),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    'ornate floral filigree and lattice details dazzle in this 18 karat yellow gold finger ring, blending traditional artistry with modern elegance.',
                    style: FFontStyles.cartLabel(14),
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
                    decoration: BoxDecoration(
                      color: AppColors.detailsCardBG,
                      border: Border.all(
                        color: AppColors.detailsCardBorder
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      children: [
                        DetailsPageRow(label: 'Weight', value: '2.4 g'),
                        SizedBox(height: height * 0.01),
                        DetailsPageRow(label: 'Purity', value: '22 carat gold'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _quantity > 0
          ? FloatingActionButton.extended(
        onPressed: (){
          Navigator.pushNamed(context, AppRoutes.cartPage);
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.0, vertical: height * 0.02),
          child: Row(
            children: [
              // Stack of overlapping images
              SizedBox(
                width: width * 0.12,
                child: CircleAvatar(
                  radius: height * 0.023,
                  backgroundImage: AssetImage(additionalImages[0]), // only the first image
                ),
              ),

              SizedBox(width: width * 0.02),
              Text('View Cart', style: FFontStyles.button(16)),
            ],
          ),
        ),
      )
          : null,


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: Container(
        color: Colors.black87, // same background for both states
        padding: EdgeInsets.symmetric(vertical: height * 0.03, horizontal: width * 0.04),
        child: _quantity > 0
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity',
              style: FFontStyles.addtoCard(20),
            ),
            Row(
              children: [
                // Decrement button
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: height * 0.05, // make it square for perfect circle
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: AppColors.loginTextTheme,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 0.96
                      )
                    ),
                    child: Center(
                      child: Text('-', style: TextStyle(fontSize: 25)),
                    ),
                  ),
                ),

                SizedBox(width: width * 0.03),

                // Quantity display with background
                Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  decoration: BoxDecoration(
                      color: AppColors.loginTextTheme,
                    borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                          color: AppColors.primary
                      )
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _quantity < 10 ? '0$_quantity' : '$_quantity', // always double digits
                    style: FFontStyles.quantity(14),
                  ),
                ),

                SizedBox(width: width * 0.03),

                // Increment button
                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: height * 0.05,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: AppColors.loginTextTheme,
                      shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary,
                            width: 0.96
                        )
                    ),
                    child: Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),

          ],
        )
            : GestureDetector(
          onTap: _addToCart,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, color: AppColors.background, size: width * 0.06),
              SizedBox(width: width * 0.02),
              Text(
                'Add to Cart',
                style: FFontStyles.addtoCard(16),
              ),
            ],
          ),
        ),
      ),

    );
  }
}