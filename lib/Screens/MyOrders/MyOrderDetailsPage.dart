import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/date_utils.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyOrderDetailsPage extends StatefulWidget {
  final String orderId;
  const MyOrderDetailsPage({super.key, required this.orderId});

  @override
  State<MyOrderDetailsPage> createState() => _MyOrderDetailsPageState();
}

class _MyOrderDetailsPageState extends State<MyOrderDetailsPage> {
  bool isLoading = false;

  Map<String, dynamic>? orderData;

  @override
  void initState() {
    super.initState();
    context.read<MyOrdersBloc>().add(
      FetchOrderDetailsEventHandler(orderId: widget.orderId, page: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Orders'),
      body: BlocListener<MyOrdersBloc, MyOrdersState>(
        listener: (context, state) {
          if (state is OrderDetailsLoading) {
            setState(() => isLoading = true);
          } else if (state is OrderDetailsLoaded) {
            developer.log('orderData: ${state.orderData}');
            setState(() {
              orderData = state.orderData;
              isLoading = false;
            });
          } else if (state is OrderDetailsError) {
            setState(() => isLoading = false);
          }
        },
        child: isLoading
            ? MyOrderDetailsPageShimmer()
            : orderData == null
            ?  Center(child: Text('No order details found',maxLines: 2, style: FFontStyles.noAccountText(14)))
            : ListView(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.008),
          children: [
            ParallaxFadeIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderData!['orderId'] ?? '',
                              style: FFontStyles.cartTitle(14)),
                          SizedBox(height: height * 0.005),
                          Text(
                              formatDate(orderData!['createdAt']),
                              style: FFontStyles.cartTitle(18)),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.006,
                        ),
                        decoration: BoxDecoration(
                          color: orderData!['status']
                              .toString()
                              .toLowerCase() ==
                              'pending'
                              ? AppColors.myOrdersPending
                              .withOpacity(0.1)
                              : AppColors.myOrdersApproved
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          orderData!['status'] ?? '',
                          style: FFontStyles.myOrdersStatus(14)
                              .copyWith(
                            color: orderData!['status']
                                .toString()
                                .toLowerCase() ==
                                'pending'
                                ? AppColors.myOrdersPending
                                : AppColors.myOrdersApproved,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),

                  // Order items
                  ...List<Map<String, dynamic>>.from(orderData!['items']).map((item) {
                    final product = item['product'];
                    return Column(
                      children: [
                        OrderDetailsCard(
                          name: product['productname'],
                          purity: product['purity'],
                          weight: product['weight'],
                          quantity: item['quantity'].toString(),
                          imagePath: (product['images'] is List && (product['images'] as List).isNotEmpty)
                              ? '${ApiConstants.imageUrl}${product['images'][0]}'
                              : null,
                          height: height,
                          width: width,
                        ),
                      ],
                    );
                  }).toList(),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
