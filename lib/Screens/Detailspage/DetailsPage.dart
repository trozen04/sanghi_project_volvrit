import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

import '../../Utils/PrefUtils.dart';

class DetailsPage extends StatefulWidget {
  final String productId;
  const DetailsPage({super.key, required this.productId});


  @override
  _DetailsPageState createState() => _DetailsPageState();
}


class _DetailsPageState extends State<DetailsPage> {
  int _quantity = 0;
  String? _currentImage; // can be null until product loads
  bool isLoading = false;
  Map<String, dynamic>? product;

  @override
  void initState() {
    super.initState();
    developer.log('token: ${Prefs.getUserToken()}');
    context.read<DashboardBloc>().add(
      FetchProductDetailsEventHandler(productId: widget.productId),
    );
  }

  void _addToCart() {
    context.read<DashboardBloc>().add(AddToCartEventHandler(productId: widget.productId));
  }

  void _increment() {
    context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(productId: widget.productId, action: 'increase'));
  }

  void _decrement() {
    //context.read<DashboardBloc>().add(RemoveFromCartEventHandler(productId: widget.productId));
    context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(productId: widget.productId, action: 'decrease'));
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

    final productImages = (product?['images'] as List<dynamic>?)
        ?.map((img) => img.toString())
        .toList() ??
        [];

    final stock = product?['stock'] ?? 0;
    final productName = product?['productname'] ?? "Unknown Product";
    final weight = product?['weight'] ?? "-";
    final purity = product?['purity'] ?? "-";
    final description =
        product?['description'] ?? "No description available.";

    return Scaffold(
      appBar: CustomAppBar(title: 'Details'),
      body: MultiBlocListener(
        listeners: [
          // Product Details
          BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is ProductDetailsLoading) {
                setState(() => isLoading = true);
              } else if (state is ProductDetailsLoaded) {
                developer.log('ProductDetailsLoaded: ${state.quantity}');
                setState(() {
                  _quantity = state.quantity;
                  product = state.product;
                  isLoading = false;
                  final imgs = (product?['images'] as List<dynamic>?);
                  _currentImage =
                  imgs != null && imgs.isNotEmpty ? imgs.first : null;
                });
              } else if (state is ProductDetailsError) {
                setState(() => isLoading = false);
                TopSnackbar.show(context, message: state.message, isError: true);
              }

            },
          ),

          // Add to cart listener
          BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              if (state is AddToCartSuccess) {
                var responseData = state.response;
                var cartData = responseData['cart'];
                developer.log('AddToCartSuccess: $cartData');

                setState(() {
                  _quantity = (cartData['items'] != null && cartData['items'].isNotEmpty)
                      ? cartData['items'][0]['quantity'] ?? 0
                      : 0;
                  developer.log('_quantity: $_quantity');

                });
                TopSnackbar.show(context, message: "Item added to cart");
              } else if (state is AddToCartError) {
                TopSnackbar.show(context, message: state.message);
              }
            },
          ),

          // Remove from cart listener
          BlocListener<DashboardBloc, DashboardState>(
            listener: (context, state) {
              //Updated Cart
              if(state is AddOrRemoveCartSuccess) {
                var responseData = state.response;
                var cartData = responseData['cart'];
                developer.log('AddOrRemoveCartSuccess responseData: $responseData');
                setState(() {
                  _quantity = (cartData['items'] != null && cartData['items'].isNotEmpty)
                      ? cartData['items'][0]['quantity'] ?? 0
                      : 0;
                });

              }
            },
          ),
        ],
        child: isLoading
            ? DetailsPageShimmer()
            : product == null
            ? Center(child: Text("No product found. Please try again later.",maxLines: 2, style: FFontStyles.noAccountText(14),))
            : SingleChildScrollView(
          child: StaggeredReveal(
            initialDelay: const Duration(milliseconds: 80),
            duration: const Duration(milliseconds: 900),
            staggerFraction: 0.18,
            children: [
              // Image Stack
              ImageStackWidget(
                currentImage: _currentImage ?? '',
                additionalImages: productImages,
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
                    // Name + Stock
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            productName,
                            style: FFontStyles.customAppBarTitleText(20),
                          ),
                        ),
                        if (stock > 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.005),
                            decoration: BoxDecoration(
                              color:
                              AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "$stock Stock Left",
                              style: FFontStyles.stockLeft(14),
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: height * 0.01),

                    // Description
                    Text(
                      description,
                      style: FFontStyles.cartLabel(14),
                    ),

                    SizedBox(height: height * 0.02),

                    // Specs (Weight, Purity etc.)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.03),
                      decoration: BoxDecoration(
                        color: AppColors.detailsCardBG,
                        border: Border.all(
                            color: AppColors.detailsCardBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          DetailsPageRow(
                              label: 'Weight',
                              value: weight.toString()),
                          SizedBox(height: height * 0.01),
                          DetailsPageRow(
                              label: 'Purity',
                              value: purity.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _quantity > 0
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.cartPage);
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        label: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.0, vertical: height * 0.02),
          child: Row(
            children: [
              if (productImages.isNotEmpty)
                SizedBox(
                  width: width * 0.12,
                  child: CircleAvatar(
                    radius: height * 0.023,
                    backgroundImage: NetworkImage(
                        ApiConstants.imageUrl + productImages.first),
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

      // Bottom bar
      bottomNavigationBar: Container(
        color: Colors.black87,
        padding: EdgeInsets.symmetric(
            vertical: height * 0.03, horizontal: width * 0.04),
        child: _quantity > 0
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity', style: FFontStyles.addtoCard(20)),
            Row(
              children: [
                // decrement
                GestureDetector(
                  onTap: _decrement,
                  child: Container(
                    width: height * 0.05,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: AppColors.loginTextTheme,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.primary, width: 0.96),
                    ),
                    child: Center(
                      child: Text('-', style: TextStyle(fontSize: 25)),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                // quantity text
                Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  decoration: BoxDecoration(
                    color: AppColors.loginTextTheme,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: AppColors.primary),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _quantity < 10 ? '0$_quantity' : '$_quantity',
                    style: FFontStyles.quantity(14),
                  ),
                ),
                SizedBox(width: width * 0.03),
                // increment
                GestureDetector(
                  onTap: _increment,
                  child: Container(
                    width: height * 0.05,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: AppColors.loginTextTheme,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.primary, width: 0.96),
                    ),
                    child: Center(child: Icon(Icons.add)),
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
              Icon(Icons.shopping_cart_outlined,
                  color: AppColors.background, size: width * 0.06),
              SizedBox(width: width * 0.02),
              Text('Add to Cart', style: FFontStyles.addtoCard(16)),
            ],
          ),
        ),
      ),
    );
  }
}

