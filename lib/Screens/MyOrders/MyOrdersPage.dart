import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Bloc/MyOrders/my_orders_bloc.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool showPending = true;
  bool isLoading = false;
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();
  List orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          hasMore &&
          !isLoading) {
        currentPage++;
        fetchOrders();
      }
    });
  }

  void fetchOrders() {
    context.read<MyOrdersBloc>().add(FetchOrdersEventHandler(
      action: showPending ? 'pending' : 'approved',
      page: currentPage,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(title: 'My Orders'),
      body: BlocListener<MyOrdersBloc, MyOrdersState>(
        listener: (context, state) {
          if (state is OrdersLoading) {
            setState(() => isLoading = true);
          } else if (state is OrdersLoaded) {
            setState(() {
              isLoading = false;
              if (currentPage == 1) {
                orders = state.orders;
              } else {
                orders.addAll(state.orders);
              }
              // Stop fetching if fewer orders returned than expected
              if (state.orders.length < 10) hasMore = false;
            });
          } else if (state is OrdersError) {
            setState(() => isLoading = false);

            TopSnackbar.show(context, message: state.message, isError: true);

          }
        },
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
          child: Column(
            children: [
              // Tab Buttons
              Container(
                height: height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.tabBackground,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildTabButton(
                      title: 'Pending',
                      active: showPending,
                      onTap: () {
                        setState(() {
                          showPending = true;
                          currentPage = 1;
                          hasMore = true;
                        });
                        fetchOrders();
                      },
                      height: height,
                      width: width,
                    ),
                    _buildTabButton(
                      title: 'Approved',
                      active: !showPending,
                      onTap: () {
                        setState(() {
                          showPending = false;
                          currentPage = 1;
                          hasMore = true;
                        });
                        fetchOrders();
                      },
                      height: height,
                      width: width,
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.03),
              // Orders List
              Expanded(
                child: isLoading && orders.isEmpty
                    ? MyOrdersPageShimmer()
                    : orders.isEmpty
                    ? Center(child: Text("No orders found"))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: orders.length + (hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= orders.length) {
                      // Show loading indicator at bottom
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            )),
                      );
                    }

                    final order = orders[index];

                    // Format date
                    final createdAt =
                        DateTime.tryParse(order['createdAt'] ?? '') ??
                            DateTime.now();
                    final formattedDate =
                        "${createdAt.day}-${createdAt.month}-${createdAt.year}";

                    // Map items to images (placeholder images)
                    final images = (order['items'] as List)
                        .expand<String>((item) {
                      final imgs = item['product']['images'] as List?;
                      if (imgs != null && imgs.isNotEmpty) {
                        return imgs.map((e) => e.toString().replaceAll("\\", "/"));
                      }
                      return [];
                    })
                        .toList();


                    return Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.myOrderDetailsPage,
                          arguments: order['orderId'],
                        ),
                        child: OrderCard(
                          orderId: order['orderId'] ?? '',
                          date: formattedDate,
                          status: order['status'] ?? '',
                          statusColor: order['status'] == 'pending'
                              ? AppColors.myOrdersPending
                              : AppColors.myOrdersApproved,
                          images: images,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required bool active,
    required VoidCallback onTap,
    required double height,
    required double width,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: height * 0.06,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: FFontStyles.addtoCard(14).copyWith(
              color: active ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
