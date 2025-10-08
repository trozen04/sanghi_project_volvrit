import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/CartContainer.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

class CartPage extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const CartPage({super.key, this.onBackToHome});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = true;
  bool buttonLoading = false;
  bool isSubmitted = false;
  List<Map<String, dynamic>> cartItems = [];
  String? deletingProductId;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _fetchData() {
    context.read<DashboardBloc>().add(FetchCartPageEventHandler());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Cart',
        onLeadingTap: widget.onBackToHome ?? () => Navigator.pop(context),
      ),
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is CartPageLoading) {
            setState(() => isLoading = true);
          }
          else if (state is CartPageLoaded) {
            developer.log('cart data: ${state.cartData}');
            final response = state.cartData['cart'] as Map<String, dynamic>? ?? {};
            final items = response['items'] as List<dynamic>? ?? [];

            setState(() {
              cartItems = items.where((item) => item['product'] != null).map((item) {
                final product = item['product'] as Map<String, dynamic>;
                return {
                  '_id': product['_id'],
                  'title': product['productname'] ?? 'Product',
                  'image': (product['images'] is List && (product['images'] as List).isNotEmpty)
                      ? '${ApiConstants.imageUrl}${product['images'][0]}'
                      : null,
                  'purity': product['purity'] ?? '',
                  'weight': product['weight'] ?? '',
                  'quantity': item['quantity'] ?? 1,
                  'stock': product['stock'] ?? 0,
                };
              }).toList();
              isLoading = false;
            });

          }
          else if (state is removeFromCartLoading) {
            setState(() {
              deletingProductId = state.productId;
            });          }
          else if (state is removeFromCartSuccess) {
            // extract updated cart items
            final updatedItems = state.response['cart']?['items'] as List<dynamic>? ?? [];

            // get the product IDs from updated cart
            final updatedProductIds = updatedItems.map((e) => e['product']).toSet();

            setState(() {
              // remove only those not present anymore
              cartItems.removeWhere((item) => !updatedProductIds.contains(item['_id']));
              deletingProductId = null;

            });

            TopSnackbar.show(context, message: 'Item removed successfully');
          }

          else if (state is removeFromCartError) {
            setState(() => isLoading = false);
            TopSnackbar.show(context, message: state.message, isError: true);
          }
          else if (state is CartPageError) {
            setState(() => isLoading = false);
            TopSnackbar.show(context, message: state.message, isError: true);
          }

          if(state is SubmitCartLoading) {
            setState(() {
              buttonLoading = true;
            });
          } else if(state is SubmitCartSuccess) {
            developer.log('SubmitCartSuccess: ${state.response}');
            setState(() {
              cartItems = [];
              buttonLoading = false;
              isSubmitted = true;
            });
            TopSnackbar.show(context, message: "Your order has been placed.");
          } else if(state is SubmitCartError) {
            developer.log('error: ${state.message}');
            setState(() {
              buttonLoading = false;
            });
            TopSnackbar.show(context, message: "Oops! Something went wrong. Please try again later.", isError: true);

          }
        },
        child: isLoading
            ? CartPageShimmer()
            : Column(
          children: [
            // This takes all space above the cart summary
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.03,
                ),
                child: cartItems.isEmpty
                    ? Center(
                  child: Text(
                    'Your cart is empty.\nPlease add items to place an order.',
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: FFontStyles.noAccountText(14),
                  ),
                )
                    : AnimatedList(
                  key: _listKey,
                  initialItemCount: cartItems.length,
                  itemBuilder: (context, index, animation) {
                    final item = cartItems[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: CartContainer(
                        width: width,
                        height: height,
                        imagePath: item['image'],
                        title: item['title'],
                        purity: item['purity'],
                        weight: item['weight'],
                        onDelete: () async {
                          bool? confirm = await showConfirmDialog(
                            context,
                            title: "Remove Item?",
                            message:
                            "Are you sure you want to remove this item from your cart?",
                          );

                          if (confirm == true) {
                            final removedItem = cartItems[index];
                            context.read<DashboardBloc>().add(
                              RemoveFromCartEventHandler(
                                  productId: removedItem['_id']),
                            );

                            // Animate removal locally
                            _listKey.currentState?.removeItem(
                              index,
                                  (context, animation) => SizeTransition(
                                sizeFactor: animation,
                                child: CartContainer(
                                  width: width,
                                  height: height,
                                  imagePath: removedItem['image'],
                                  title: removedItem['title'],
                                  purity: removedItem['purity'],
                                  weight: removedItem['weight'],
                                ),
                              ),
                              duration:
                              const Duration(milliseconds: 400),
                            );

                            // Remove from local list and rebuild UI
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Cart summary always at bottom
            _buildCartSummary(width, height),
          ],
        ),

      ),
    );
  }

  Widget _buildCartSummary(double width, double height) {
    final totalQuantity = cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int));

    final totalWeight = cartItems.fold<double>(
      0,
          (sum, item) {
        final weightStr = item['weight']?.toString().toLowerCase() ?? '0';
        final w = double.tryParse(weightStr.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return sum + w * (item['quantity'] as int);
      },
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.025),
      decoration: BoxDecoration(
        color: AppColors.background, // Or Colors.white if you prefer
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -3), // shadow above
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: StaggeredReveal(
        initialDelay: const Duration(milliseconds: 80),
        duration: const Duration(milliseconds: 900),
        staggerFraction: 0.18,
        children: [
          Text('Total', style: FFontStyles.customAppBarTitleText(20)),
          SizedBox(height: height * 0.01),
          cartPageRow(label: 'Quantity -', value: totalQuantity.toString().padLeft(2, '0')),
          SizedBox(height: height * 0.01),
          cartPageRow(label: 'Total Weight -', value: '${totalWeight.toStringAsFixed(2)} g'),
          SizedBox(height: height * 0.02),
          ReusableButton(
            text: isSubmitted ? "Order Placed" : "Submit",
            onPressed: isSubmitted
                ? () {}
                : () {
              context.read<DashboardBloc>().add(SubmitCartEventHandler());
            },
            color: isSubmitted || cartItems.isEmpty ? Colors.grey : AppColors.primary,
            width: width,
            isLoading: buttonLoading,
          ),
        ],
      ),
    );
  }

  Future<bool?> showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        String confirmText = "Yes, Remove",
        String cancelText = "Cancel",
      }) {
    final width = MediaQuery.of(context).size.width;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: width * 0.05,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: width * 0.15,
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                    style: FFontStyles.customAppBarTitleText(18)
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: FFontStyles.noAccountText(14)
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(
                          cancelText,
                          style: FFontStyles.noAccountText(14)
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          confirmText,
                          style: FFontStyles.button(14)
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}

