import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppGraidients.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:shimmer/shimmer.dart';

import '../../Routes/app_routes.dart';
import '../../Screens/HomeScreens/Catalog/CategorySearchPage.dart';

class CustomAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  final bool showCenterText;
  final String? centerText;
  final Function(String)? onSearchSubmitted; // <-- callback

  const CustomAppBarHome({
    super.key,
    this.showCenterText = false,
    this.centerText,
    this.onSearchSubmitted,

  });

  @override
  Size get preferredSize => const Size.fromHeight(150);

  @override
  State<CustomAppBarHome> createState() => _CustomAppBarHomeState();
}

class _CustomAppBarHomeState extends State<CustomAppBarHome>
    with AutomaticKeepAliveClientMixin {
  Map<String, double> livePrices = {};
  String? selectedCarat;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch gold prices only if not loaded yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<DashboardBloc>();
      if (bloc.state is! GoldValueLoaded) {
        bloc.add(FetchGoldValueEventHandler());
      }
    });
  }

  @override
  bool get wantKeepAlive => true; // Keep state alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is GoldValueLoading) {
          isLoading = true;
        } else if (state is GoldValueLoaded) {
          isLoading = false;
          livePrices = {
            for (var item in state.goldData)
              '${item['carat']}': (item['price'] as num).toDouble(),
          };

          // Initialize selectedCarat once after data loads
          if (selectedCarat == null && livePrices.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                selectedCarat = livePrices.keys.first;
                developer.log('Selected carat initialized: $selectedCarat');
              });
            });
          }
        } else if (state is GoldValueError) {
          isLoading = false;
          developer.log('GoldValueError: ${state.message}');
        }

        return Container(
          height: height * 0.2,
          decoration: BoxDecoration(
            gradient: AppGradients.topToBottom,
            image: DecorationImage(
              image: AssetImage(ImageAssets.LoginBG),
              fit: BoxFit.cover,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              livePrices.isEmpty
                  ? SizedBox.shrink()
                  : Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.008),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(ImageAssets.liveIcon, width: width * 0.06),
                        Text('Live', style: FFontStyles.liveText(10)),
                      ],
                    ),
                    SizedBox(width: width * 0.03),
                    SizedBox(
                      width: width * 0.25,
                      child: isLoading
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 50, // Set a fixed height to match DropdownButton
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                          : DropdownButton<String>(
                        value: selectedCarat ?? livePrices.keys.firstOrNull,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                        dropdownColor: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        items: livePrices.keys.map((carat) {
                          return DropdownMenuItem<String>(
                            value: carat,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${carat.toUpperCase()} Carat Price',
                                  style: FFontStyles.liveText(10).copyWith(color: Colors.black),
                                ),
                                FittedBox(
                                  child: Text(
                                    '₹${livePrices[carat]!.toStringAsFixed(2)}/g',
                                    style: FFontStyles.caratPrice(14).copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: livePrices.isEmpty
                            ? null
                            : (value) {
                          setState(() => selectedCarat = value!);
                        },
                        underline: SizedBox(), // ✅ removes the default underline

                      ),
                    )

                  ],
                ),
              ),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notificationPage),
                    child: Image.asset(
                      ImageAssets.notificationIcon,
                      width: width * 0.1,
                      color: AppColors.background,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _circleIcon(Icons.search_rounded, width, context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _circleIcon(IconData icon, double width, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CategorySearchPage()),
        );

        if (result != null && result is String) {
          print('User searched for: $result');

          // <-- Call the callback here so CategoryScreen gets the query
          if (widget.onSearchSubmitted != null) {
            widget.onSearchSubmitted!(result);
          }
        }
      },
      child: Container(
        width: width * 0.1,
        height: width * 0.1,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.background, width: 1.5),
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon, color: AppColors.background, size: width * 0.06),
      ),
    );
  }

}
