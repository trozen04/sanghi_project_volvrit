import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppGraidients.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:shimmer/shimmer.dart';

class CustomAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBarHome({super.key});

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
              Image.asset(ImageAssets.appLogo, height: height * 0.07),
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
                        items: livePrices.isEmpty
                            ? [
                          DropdownMenuItem<String>(
                            value: '',
                            child: Text('No data', style: FFontStyles.liveText(14).copyWith(color: Colors.grey)),
                          ),
                        ]
                            : livePrices.keys.map((carat) {
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
                                Text(
                                  '₹${livePrices[carat]!.toStringAsFixed(2)}/g',
                                  style: FFontStyles.caratPrice(14).copyWith(color: Colors.black),
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
            ],
          ),
        );
      },
    );
  }
}
