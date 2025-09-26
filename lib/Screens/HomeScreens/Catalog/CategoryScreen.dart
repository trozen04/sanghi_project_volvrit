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
  List<String> selectedCategories = [];
  List<String> selectedFilters = [];
  List<String> selectedSort = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CategoryAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: isLoading
            ? CategoryScreenShimmer()
            : ParallaxFadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // CATEGORY BUTTON
                  ActionButton(
                    icon: Icons.grid_view_outlined,
                    label: 'Category',
                    onTap: () async {
                      final result = await showMultiSelectDialog(
                        context: context,
                        title: 'Select Category',
                        options: const [
                          'Gold Rings',
                          'Gold Neckless',
                          'Gold Bangles',
                          'Gold Earrings',
                        ],
                        initiallySelected: selectedCategories,
                      );
                      if (result != null) {
                        setState(() => selectedCategories = result);
                      }
                    },
                  ),

                  Row(
                    children: [
                      // FILTER BUTTON
                      ActionButton(
                        icon: Icons.filter_list_rounded,
                        label: 'Filter',
                        onTap: () async {
                          final result = await showMultiSelectDialog(
                            context: context,
                            title: 'Select Filter',
                            options: const ['Men', 'Women', 'Kids'],
                            initiallySelected: selectedFilters,
                          );
                          if (result != null) {
                            setState(() => selectedFilters = result);
                          }
                        },
                      ),
                      SizedBox(width: width * 0.02),

                      // SORT BUTTON
                      ActionButton(
                        icon: Icons.keyboard_arrow_down_outlined,
                        label: 'Sort By',
                        isRight: true,
                        onTap: () async {
                          final result = await showMultiSelectDialog(
                            context: context,
                            title: 'Sort By',
                            options: const ['Price: Low to High', 'Price: High to Low'],
                            initiallySelected: selectedSort,
                          );
                          if (result != null) {
                            setState(() => selectedSort = result);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Text('Gold Rings', style: FFontStyles.titleText(18)),
              const SizedBox(height: 12),

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
