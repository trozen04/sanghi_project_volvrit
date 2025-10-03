import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

class MyOrderDetailsPage extends StatefulWidget {
  final String orderId;
  const MyOrderDetailsPage({super.key, required this.orderId});

  @override
  State<MyOrderDetailsPage> createState() => _MyOrderDetailsPageState();
}

class _MyOrderDetailsPageState extends State<MyOrderDetailsPage> {
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<MyOrdersBloc>().add(FetchOrderDetailsEventHandler(orderId: widget.orderId));
  }

  final List<Map<String, dynamic>> orders = [
    {
      'id': '#1202012',
      'date': '12-Sep-2025',
      'items': [
        {'name': 'Regal Floral Gold Ring', 'purity': '22 carat', 'weight': '2.4 g', 'quantity': '20 Qty'},
        {'name': 'Regal Floral Gold Ring', 'purity': '22 carat', 'weight': '2.4 g', 'quantity': '20 Qty'},
        {'name': 'Regal Floral Gold Ring', 'purity': '22 carat', 'weight': '2.4 g', 'quantity': '20 Qty'},
      ],
      'status': 'Pending',
    },
  ];

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
            setState(() {
              isLoading = false;

            });
          } else if (state is OrderDetailsError) {
            setState(() => isLoading = false);
            //TopSnackbar.show(context, message: state.message, isError: true);
          }
        },
  child: Column(
        children: [
          isLoading
              ? MyOrderDetailsPageShimmer()
              : Expanded(
                child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.008),
                            itemCount: orders.length,
                            itemBuilder: (context, index) {
                final order = orders[index];
                return ParallaxFadeIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order['id'], style: FFontStyles.cartTitle(14),),
                              SizedBox(height: height * 0.005),
                              Text(order['date'],  style: FFontStyles.cartTitle(18)),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.006,
                            ),
                            decoration: BoxDecoration(
                              color: order['status'] == "Pending"
                                  ? AppColors.myOrdersPending.withOpacity(0.1)
                              : AppColors.myOrdersApproved.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              order['status'],
                              style: FFontStyles.myOrdersStatus(14).copyWith(
                                color: order['status'] == "Pending"
                                    ? AppColors.myOrdersPending
                                    : AppColors.myOrdersApproved,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      ...order['items'].map((item) => OrderDetailsCard(
                        name: item['name'],
                        purity: item['purity'],
                        weight: item['weight'],
                        quantity: item['quantity'],
                        height: height,
                        width: width,
                      )).toList(),
                      SizedBox(height: height * 0.02),
                    ],
                  ),
                );
                            },
                          ),
              ),
        ],
      ),
),
    );
  }
}