import 'package:flutter/material.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool showPending = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    // sample order data
    final orders = [
      {
        'id': '1202012',
        'date': '12-Sep-2025',
        'status': 'Approved',
        'images': [
          ImageAssets.RingImage,
          ImageAssets.RingImage,
        ]
      },
       {
        'id': '1202015',
        'date': '12-Sep-2025',
        'status': 'Approved',
        'images': [
          ImageAssets.RingImage,
          ImageAssets.RingImage,
        ]
      },
       {
        'id': '1202016',
        'date': '12-Sep-2025',
        'status': 'Pending',
        'images': [
          ImageAssets.RingImage,
          ImageAssets.RingImage,
        ]
      },

      {
        'id': '1202013',
        'date': '12-Sep-2025',
        'status': 'Pending',
        'images': [
          ImageAssets.RingImage,
        ]
      },
      {
        'id': '1202014',
        'date': '12-Sep-2025',
        'status': 'Pending',
        'images': [
          ImageAssets.RingImage,
        ]
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'My Orders'),
      body: isLoading
          ? MyOrdersPageShimmer()
          : Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: Column(
          children: [
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
                    onTap: () => setState(() => showPending = true),
                    height: height,
                    width: width,
                  ),
                  _buildTabButton(
                    title: 'Approved',
                    active: !showPending,
                    onTap: () => setState(() => showPending = false),
                    height: height,
                    width: width,
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),
            // -------- Orders List --------
            Expanded(
              child: ListView.builder(
                itemCount: orders
                    .where((order) =>
                showPending ? order['status'] == 'Pending' : order['status'] == 'Approved')
                    .length,
                itemBuilder: (context, index) {
                  final filteredOrders = orders
                      .where((order) =>
                  showPending ? order['status'] == 'Pending' : order['status'] == 'Approved')
                      .toList();
                  final order = filteredOrders[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.myOrderDetailsPage),
                      child: OrderCard(
                        orderId: (order['id'] ?? '') as String,
                        date: (order['date'] ?? '') as String,
                        status: order['status'] as String,
                        statusColor: order['status'] == 'Pending'
                            ? AppColors.myOrdersPending
                            : AppColors.myOrdersApproved,
                        images: (order['images'] ?? []) as List<String>,
                      ),
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
            overflow: TextOverflow.ellipsis, // prevent overflow
            style: FFontStyles.addtoCard(14).copyWith(
              color: active ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
