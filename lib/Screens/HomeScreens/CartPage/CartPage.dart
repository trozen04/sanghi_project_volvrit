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
                      : ImageAssets.RingImage,
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
            setState(() => isLoading = true);
          }
          else if (state is removeFromCartSuccess) {
            setState(() {
              _fetchData();
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
          child: isLoading
              ? CartPageShimmer()
              : Column(
            children: [
              Expanded(
                child: cartItems.isEmpty
                    ? Center(child: Text('Your cart is empty.\nPlease add items to place an order.',
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: FFontStyles.noAccountText(14),
                    ))
                    : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    print('item: $item');
                    return CartContainer(
                      width: width,
                      height: height,
                      imagePath: item['image'],
                      title: item['title'],
                      purity: item['purity'],
                      weight: item['weight'],
                      onDelete: () {
                        context.read<DashboardBloc>().add(RemoveFromCartEventHandler(productId: item['_id']));
                      },

                    );
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              _buildCartSummary(width, height),
            ],
          ),
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


    return StaggeredReveal(
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
              ? (){} // disables the button if already submitted
              : () {
            context.read<DashboardBloc>().add(SubmitCartEventHandler());
          },
          color: isSubmitted || cartItems.isEmpty ? Colors.grey : AppColors.primary,
          width: width,
          isLoading: buttonLoading,
        ),
      ],
    );
  }
}

