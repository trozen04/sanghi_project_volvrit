import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppGraidients.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class CustomAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBarHome({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(150.0);

  @override
  State<CustomAppBarHome> createState() => _CustomAppBarHomeState();
}

class _CustomAppBarHomeState extends State<CustomAppBarHome> {
  String selectedCarat = '24K Carat'; // Default value matching data format

  @override
  Widget build(BuildContext context)  {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        Map<String, double> livePrices = {};
        bool isLoading = true;

        developer.log('CustomAppBarHome state: $state'); // Log state for debugging

        if (state is GoldValueLoading) {
          isLoading = true;
        } else if (state is GoldValueLoaded) {
          isLoading = false;
          developer.log('Gold prices: ${state.goldData}');
          livePrices = {
            for (var item in state.goldData) // Iterate over List
              '${item['carat']}': (item['price'] as num).toDouble(),
          };

          // Ensure selectedCarat is valid
          if (!livePrices.containsKey(selectedCarat)) {
            selectedCarat = livePrices.keys.firstOrNull ?? '24K Carat';
          }
        } else if (state is GoldValueError) {
          developer.log('Error: ${state.message}');
          isLoading = false;
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
              // App Logo
              Image.asset(ImageAssets.appLogo, height: height * 0.07),
              // Live Price Dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.008),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(strokeWidth: 2)
                    : livePrices.isEmpty
                    ? Text('No prices available', style: FFontStyles.liveText(10))
                    : Row(
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
                      child: DropdownButton<String>(
                        value: selectedCarat,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                        dropdownColor: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        items: livePrices.keys.map((carat) {
                          return DropdownMenuItem<String>(
                            value: carat,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$carat Carat Price',
                                  style: FFontStyles.liveText(10).copyWith(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '₹${livePrices[carat]!.toStringAsFixed(2)}/g',
                                  style: FFontStyles.caratPrice(14).copyWith(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCarat = value!;
                            developer.log('Selected carat: $selectedCarat');
                          });
                        },
                      ),
                    ),
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