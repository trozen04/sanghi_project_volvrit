import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/MultiSelectDialog.dart';
import 'package:gold_project/Widgets/ProductCard.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';
import 'package:gold_project/Widgets/action_button.dart';
import 'package:gold_project/Widgets/AppBar/category_app_bar.dart';
import 'dart:developer' as developer;
import 'dart:convert';

import '../../../Widgets/AppBar/custom_appbar_home.dart';
import 'dart:async';

class CategoryScreen extends StatefulWidget {
  final String searchQuery;
  const CategoryScreen({super.key, this.searchQuery = ''});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  dynamic selectedCategories = {'main': [], 'side': {}};
  dynamic selectedFilters = {'main': [], 'side': {}};
  bool isLoading = true;
  bool isCategoriesLoaded = false;
  List<dynamic> categories = [];
  List<Map<String, dynamic>> products = [];
  GlobalKey categoryKey = GlobalKey();
  GlobalKey filterKey = GlobalKey();
  String searchQuery = '';
  Timer? _debounceTimer;

  Map<String, String?> parseWeight(String? weight) {
    if (weight == null) return {'minWeight': null, 'maxWeight': null};
    if (weight.startsWith('<')) {
      return {'minWeight': null, 'maxWeight': weight.replaceFirst('<', '').replaceAll('g', 'gr')};
    } else if (weight.startsWith('>')) {
      return {'minWeight': weight.replaceFirst('>', '').replaceAll('g', 'gr'), 'maxWeight': null};
    } else {
      final parts = weight.split('-');
      if (parts.length == 2) {
        return {
          'minWeight': parts[0].replaceAll('g', 'gr'),
          'maxWeight': parts[1].replaceAll('g', 'gr'),
        };
      }
    }
    return {'minWeight': null, 'maxWeight': null};
  }

  void triggerApi({
    String? categoryName,
    String? subCategoryName,
    String? purity,
    String? minWeight,
    String? maxWeight,
    String? search,
  }) {
    developer.log(
        'params: categoryName=$categoryName, subCategoryName=$subCategoryName, purity=$purity, minWeight=$minWeight, maxWeight=$maxWeight, search=$search');
    context.read<DashboardBloc>().add(FetchCategoryListEventHandler(
      token: Prefs.getUserToken() ?? '',
      categoryName: categoryName,
      subCategoryName: subCategoryName,
      purity: purity,
      minWeight: minWeight,
      maxWeight: maxWeight,
      searchQuery: search,
    ));
  }

  @override
  void initState() {
    super.initState();
    triggerApi();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
    //       !isLoadingMore &&
    //       hasMore &&
    //       !isLoading) {
    //     // Load next page
    //     currentPage++;
    //     fetchMoreProducts();
    //   }
    // });
  }

  @override
  void didUpdateWidget(CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      triggerApi(
        categoryName: selectedCategories['main'].isNotEmpty
            ? selectedCategories['main'][0]
            : null,
        search: widget.searchQuery,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is ProductListLoading) {
            setState(() {
              isLoading = true;
            });
          } else if (state is ProductListLoaded) {
            final productData = state.responseData as Map<String, dynamic>;
            setState(() {
              if (!isCategoriesLoaded && productData.containsKey('categories')) {
                categories = productData['categories'] as List? ?? [];
                isCategoriesLoaded = true;
              }
              products.clear();
              var categoryData = productData['categories'] as List? ?? [];
              for (var category in categoryData) {
                final subcategories = category['subcategories'] as List? ?? [];
                for (var subcategory in subcategories) {
                  final subcategoryProducts = subcategory['products'] as List? ?? [];
                  products.addAll(subcategoryProducts.cast<Map<String, dynamic>>());
                }
              }
              isLoading = false;
            });
          } else if (state is ProductListError) {
            setState(() {
              isLoading = false;
            });
            TopSnackbar.show(context, message: state.message, isError: true);
          } else if (state is AddToCartSuccess) {
            final responseData = state.response;
            developer.log('res: ${responseData}');

            // setState(() {
            //   for (var product in products) {
            //     final index = products.indexOf(product);
            //     final item = cartItems.firstWhere(
            //           (e) => e['product'] == product['_id'],
            //       orElse: () => null,
            //     );
            //     products[index]['cartQuantity'] = item != null ? item['quantity'] ?? 0 : 0;
            //   }
            // });
            final cartItems = responseData['cart']?['items'] as List<dynamic>? ?? [];

            if (cartItems.isNotEmpty) {
              final addedProductId = cartItems.last['product']; // get the last added product

              setState(() {
                products.removeWhere((p) => p['_id'] == addedProductId);
              });
            }
            TopSnackbar.show(context, message: 'Cart updated successfully');
          } else if (state is AddOrRemoveCartSuccess) {
            final responseData = state.response;
            final cartItems = responseData['cart']['items'] as List<dynamic>? ?? [];
            setState(() {
              for (var product in products) {
                final index = products.indexOf(product);
                final item = cartItems.firstWhere(
                      (e) => e['product'] == product['_id'],
                  orElse: () => null,
                );
                products[index]['cartQuantity'] = item != null ? item['quantity'] ?? 0 : 0;
              }
            });
            TopSnackbar.show(context, message: 'Cart updated successfully');
          } else if (state is AddToCartError) {
            TopSnackbar.show(context, message: state.message, isError: true);
          } else if (state is AddOrRemoveCartError) {
            TopSnackbar.show(context, message: state.message, isError: true);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
          child: isLoading
              ? const CategoryScreenShimmer()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ActionButton(
                    key: categoryKey,
                    icon: Icons.grid_view_outlined,
                    label: 'Category',
                    onTap: () async {
                      if (!isCategoriesLoaded) {
                        developer.log('Categories not loaded yet, skipping dropdown');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Categories are still loading, please wait'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                        return;
                      }

                      final sideOptionsMap = Map.fromEntries(
                        categories.map((cat) => MapEntry(
                          cat['categoryname'] as String,
                          (cat['subcategories'] as List)
                              .map((sub) => sub['subcategoryname'] as String)
                              .toList(),
                        )),
                      );
                      developer.log('Category sideOptionsMap: $sideOptionsMap');

                      final result = await showMultiSelectDropdown(
                        context: context,
                        key: categoryKey,
                        enableSideDropdown: true,
                        singleSelection: true,
                        singleSideSelection: true,
                        title: 'Select Category',
                        options: categories.map((cat) => cat['categoryname'] as String).toList(),
                        sideOptionsMap: sideOptionsMap,
                        initiallySelected: selectedCategories,
                        onSelected: (mainSelected, sideSelectedMap) {
                          developer.log('Category onSelected: main=$mainSelected, side=$sideSelectedMap');
                          setState(() {
                            selectedCategories = {
                              'main': mainSelected,
                              'side': sideSelectedMap,
                            };
                          });

                          final mainCategory = mainSelected.isNotEmpty ? mainSelected[0] : null;
                          final subCategory = mainCategory != null &&
                              sideSelectedMap[mainCategory]?.isNotEmpty == true
                              ? sideSelectedMap[mainCategory]![0]
                              : null;

                          final purity = selectedFilters['side']?['Purity']?.isNotEmpty == true
                              ? selectedFilters['side']['Purity'][0]
                              : null;
                          final weight = selectedFilters['side']?['Weight']?.isNotEmpty == true
                              ? selectedFilters['side']['Weight'][0]
                              : null;
                          final weightParams = parseWeight(weight);

                          developer.log(
                              'Triggering API with category=$mainCategory, subCategory=$subCategory, purity=$purity, minWeight=${weightParams['minWeight']}, maxWeight=${weightParams['maxWeight']}');
                          triggerApi(
                            categoryName: mainCategory,
                            subCategoryName: subCategory,
                            purity: purity,
                            minWeight: weightParams['minWeight'],
                            maxWeight: weightParams['maxWeight'],
                          );
                        },
                      );

                      developer.log('Category dropdown result: $result');
                      if (result != null) {
                        setState(() {
                          selectedCategories = result;
                        });
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
                        key: filterKey,
                        enableSideDropdown: true,
                        singleSideSelection: true,
                        title: 'Select Filter',
                        options: const ['Weight', 'Purity'],
                        sideOptionsMap: const {
                          'Weight': ['<3g', '3-5g', '5-7g', '7-10g', '10-12g', '12-15g', '15-17g', '17-20g', '>20g'],
                          'Purity': ['18k', '20k', '22k', '24k'],
                        },
                        initiallySelected: selectedFilters,
                        onSelected: (mainSelected, sideSelectedMap) {
                          developer.log('Filter onSelected: main=$mainSelected, side=$sideSelectedMap');
                          setState(() {
                            selectedFilters = {
                              'main': mainSelected,
                              'side': sideSelectedMap,
                            };
                          });

                          // Check if there were prior side selections
                          final hadSideSelections = (selectedFilters['side'] as Map).isNotEmpty;

                          // Only trigger API if there were prior side selections or side selections have changed
                          if (hadSideSelections || sideSelectedMap.isNotEmpty) {
                            final purity = sideSelectedMap['Purity']?.isNotEmpty == true
                                ? sideSelectedMap['Purity']![0]
                                : null;
                            final weight = sideSelectedMap['Weight']?.isNotEmpty == true
                                ? sideSelectedMap['Weight']![0]
                                : null;
                            final weightParams = parseWeight(weight);

                            final mainCategory = (selectedCategories['main'] as List).isNotEmpty
                                ? selectedCategories['main'][0]
                                : null;
                            final subCategory = mainCategory != null &&
                                (selectedCategories['side'] as Map)[mainCategory]?.isNotEmpty == true
                                ? selectedCategories['side'][mainCategory][0]
                                : null;

                            developer.log(
                                'Triggering API with category=$mainCategory, subCategory=$subCategory, purity=$purity, minWeight=${weightParams['minWeight']}, maxWeight=${weightParams['maxWeight']}');
                            triggerApi(
                              categoryName: mainCategory,
                              subCategoryName: subCategory,
                              purity: purity,
                              minWeight: weightParams['minWeight'],
                              maxWeight: weightParams['maxWeight'],
                            );
                          } else {
                            developer.log('Skipping API trigger: No prior side selections and no new side selections');
                          }
                        },
                      );
                      developer.log('Filter dropdown result: $result');
                      if (result != null) {
                        setState(() {
                          selectedFilters = result;
                        });
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Text(
                selectedCategories['main'].isNotEmpty
                    ? selectedCategories['main'][0]
                    : 'All Products',
                style: FFontStyles.titleText(18),
              ),
              SizedBox(height: height * 0.01),
              Expanded(
                child: products.isEmpty && !isLoading
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(
                      id: product['_id'],
                      title: product['productname']?.toString() ?? 'Product',
                      imagePath: (product['images'] is List && (product['images'] as List).isNotEmpty)
                          ? '${ApiConstants.imageUrl}${product['images'][0]}'
                          : null,
                      stockLabel: product['stock'] ?? 0,
                      onAdd: () {
                        context.read<DashboardBloc>().add(AddToCartEventHandler(productId: product['_id']));
                      },
                      onIncrement: () {
                        context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(productId: product['_id'], action: 'increase'));
                      },
                      onDecrement: () {
                        context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(productId: product['_id'], action: 'decrease'));
                      },
                      cartQuantity: product['cartQuantity'],
                      onViewCart: () {
                        Navigator.pushNamed(context, AppRoutes.cartPage);
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