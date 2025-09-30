import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/MultiSelectDialog.dart';
import 'package:gold_project/Widgets/ProductCard.dart';
import 'package:gold_project/Widgets/action_button.dart';
import 'package:gold_project/Widgets/AppBar/category_app_bar.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  dynamic selectedCategories = [];
  List<String> selectedFilters = [];
  List<String> selectedSort = [];
  bool isLoading = false;
  GlobalKey categoryKey = GlobalKey();
  GlobalKey filterKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CategoryAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
        child: isLoading
            ? CategoryScreenShimmer()
            : ParallaxFadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // CATEGORY BUTTON
                  ActionButton(
                    key: categoryKey,
                    icon: Icons.grid_view_outlined,
                    label: 'Category',
                    onTap: () async {
                        final result = await showMultiSelectDropdown(
                          context: context,
                          key: categoryKey,
                          enableSideDropdown: true,
                          title: 'Select Category',
                          options: const ['Gold Rings', 'Gold Neckless', 'Gold Bangles', 'Gold Earrings'],
                          sideOptionsMap: const {
                            'Gold Rings': ['Men', 'Women', 'Kids'],
                            'Gold Neckless': ['Men', 'Women', 'Kids'],
                            'Gold Bangles': ['Men', 'Women', 'Kids'],
                            'Gold Earrings': ['Men', 'Women', 'Kids'],
                          },
                          initiallySelected: selectedCategories,
                          onSelected: (selectedList) {
                            setState(() => selectedCategories = selectedList);
                          },
                        );

                      // Print the final selected items when dropdown(s) are closed
                      print('Final selection: $result');

                      if (result != null) {
                        setState(() => selectedCategories = result);
                      }
                    },
                  ),
                  SizedBox(width: width * 0.05),
                  ActionButton(
                    key: filterKey,
                    icon: Icons.filter_list_rounded,
                    label: 'Filter',
                    onTap: () async {
                      final result = await showMultiSelectDropdown(
                        context: context,
                        enableSideDropdown: true,
                        title: 'Select Filter',
                        options: const ['Weight', 'Purity'],
                        sideOptionsMap: const {
                          'Weight': ['<3g','3-5g', '5–7g', '7–10g', '10–12g', '12–15g', '15–17g', '17–20g', '20g>'],
                          'Purity': ['18k', '20k', '22k', '24k'],
                        },
                        initiallySelected: selectedFilters,
                        onSelected: (selectedList) {
                          setState(() => selectedFilters = selectedList);
                        },
                        key: filterKey,
                      );
                      print('Filter selection: $result');

                      if (result != null) {
                        setState(() => selectedFilters = result);
                      }
                    },
                  ),

                  // Row(
                  //   children: [
                  //
                  //     SizedBox(width: width * 0.02),
                  //     // SORT BUTTON
                  //     ActionButton(
                  //       key: sorByKey,
                  //       icon: Icons.keyboard_arrow_down_outlined,
                  //       label: 'Sort By',
                  //       isRight: true,
                  //       onTap: () async {
                  //         final result = await showMultiSelectDropdown(
                  //           context: context,
                  //           title: 'Sort By',
                  //           singleSelection: true,
                  //           options: const ['Ascending', 'Descending'],
                  //           initiallySelected: selectedSort,
                  //           onSelected: (selectedList) {
                  //             setState(() => selectedSort = selectedList);
                  //           },
                  //           key: sorByKey
                  //         );
                  //
                  //         print('Sort selection: $result');
                  //
                  //         if (result != null) {
                  //           setState(() => selectedSort = result);
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),

                ],
              ),

              SizedBox(height: height * 0.01),
              Text('Gold Rings', style: FFontStyles.titleText(18)),
              SizedBox(height: height * 0.01),

              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      title: 'Gold Rings',
                      imagePath: ImageAssets.RingImage,
                      stockLabel: '2 Stock Left',
                      onAdd: () {
                        // handle add to cart
                      },
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
}
