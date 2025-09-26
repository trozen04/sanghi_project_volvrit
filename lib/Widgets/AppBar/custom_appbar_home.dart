import 'package:flutter/material.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/AppGraidients.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';

class CustomAppBarHome extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBarHome({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(150.0); // smaller height

  @override
  State<CustomAppBarHome> createState() => _CustomAppBarHomeState();
}

class _CustomAppBarHomeState extends State<CustomAppBarHome> {
  String selectedCarat = '24 Carat';
  final Map<String, double> livePrices = {
    '24 Carat': 11350.74,
    '22 Carat': 10350.50,
    '20 Carat': 9350.00,
    '18 Carat': 8350.25,
  };

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.2,
      decoration: BoxDecoration(
        gradient: AppGradients.topToBottom,
        image: DecorationImage(
          image: AssetImage(ImageAssets.LoginBG), // Replace with any image
          fit: BoxFit.cover, // or BoxFit.contain / BoxFit.fill
        ),
        borderRadius: BorderRadius.only(
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min, // Shrink to content
                  children: [
                    Image.asset(ImageAssets.liveIcon, width: width * 0.06),
                    Text('Live', style: FFontStyles.liveText(10)),
                  ],
                ),
                SizedBox(width: width * 0.03,),

                SizedBox(
                  width: width * 0.25,
                  child: DropdownButton<String>(
                    value: selectedCarat,
                    isExpanded: true, // ensures the dropdown matches the width
                    underline: SizedBox(),
                    icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black),
                    dropdownColor: AppColors.background, // background of the popup
                    borderRadius: BorderRadius.circular(12), // popup menu radius (Flutter >= 2.2)
                    items: livePrices.keys.map((carat) {
                      return DropdownMenuItem<String>(
                        value: carat,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(carat, style: FFontStyles.liveText(10.0)),
                            Text('${livePrices[carat]!.toStringAsFixed(2)}/g', style: FFontStyles.caratPrice(14)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCarat = value!;
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
  }
}