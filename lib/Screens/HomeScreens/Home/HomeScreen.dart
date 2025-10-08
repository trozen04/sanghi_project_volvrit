import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/ProductCard.dart';
import 'package:gold_project/Widgets/AppBar/custom_appbar_home.dart';
import 'package:gold_project/Widgets/SearchBarWidget.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  final String searchQuery;
  const HomeScreen({super.key, this.searchQuery = ''});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var categories = [];
  String selectedCategory = ''; // Default to empty, will set after data load
  bool isLoading = true; // Start with loading state for categories
  bool isLoadingProducts = false; // Loading state for products
  String token = '';
  int currentPage = 1; // Current page for pagination
  int totalPages = 1; // Total pages from API response
  List<Map<String, dynamic>> currentProducts = []; // Products for selected category
  bool isCategoriesLoaded = false; // Track if categories are loaded
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (token.isEmpty) fetchToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(FetchGoldValueEventHandler());
      context.read<DashboardBloc>().add(FetchCategoryListEventHandler(token: token));
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchQuery != oldWidget.searchQuery) {
      fetchProducts(selectedCategory, searchQuery: widget.searchQuery);
    }
  }

  void fetchToken() {
    token = Prefs.getUserToken() ?? '';
     developer.log('token: $token');
  }

  // Fetch products for the selected category
  void fetchProducts(String categoryName, {int page = 1, String? searchQuery}) {
    setState(() {
      isLoadingProducts = true;
      if (page == 1) currentProducts.clear(); // Clear products for new category or refresh
    });
    context.read<DashboardBloc>().add(FetchCategoryListEventHandler(
      token: token,
      categoryName: categoryName,
      page: page,
      searchQuery: searchQuery,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          // ------------------ PRODUCT LIST STATES ------------------
          if (state is ProductListLoading) {
            setState(() {
              if (!isCategoriesLoaded) {
                isLoading = true; // Initial category load
              } else {
                isLoadingProducts = true;
              }
            });
          }
          else if (state is ProductListLoaded) {
            final productData = state.responseData as Map<String, dynamic>;

            setState(() {
              // Initial categories load
              if (!isCategoriesLoaded && productData.containsKey('categories')) {
                categories = productData['categories'] as List? ?? [];
                if (categories.isNotEmpty) {
                  selectedCategory = (categories[0] as Map)['categoryname'] as String;
                  fetchProducts(selectedCategory, page: 1);
                }
                isCategoriesLoaded = true;
                isLoading = false;
              }
              // Products for selected category
              else {
                final products = <Map<String, dynamic>>[];
                final categoryData = (productData['categories'] as List?)
                    ?.firstWhere(
                      (cat) => cat['categoryname'] == selectedCategory,
                  orElse: () => null,
                );
                if (categoryData != null) {
                  final subcategories = categoryData['subcategories'] as List? ?? [];
                  for (var subcategory in subcategories) {
                    final subcategoryProducts = subcategory['products'] as List? ?? [];
                    products.addAll(subcategoryProducts.cast<Map<String, dynamic>>());
                  }
                }
                currentProducts.addAll(products);
                currentPage = productData['currentPage'] as int? ?? 1;
                totalPages = productData['totalPages'] as int? ?? 1;
                isLoadingProducts = false;
              }
            });

            //developer.log('Categories: ${categories.length}, Products: ${currentProducts.length}');
          }
          else if (state is ProductListError) {
            // developer.log('ProductListError: ${state.message}');
            setState(() {
              isLoading = false;
              isLoadingProducts = false;
            });
            TopSnackbar.show(
              context,
              message: state.message,
              isError: true,
            );
          }

          // ------------------ CART UPDATE STATES ------------------
          else if (state is AddToCartSuccess) {
            final responseData = state.response;
            final cartItems = responseData['cart']['items'] as List<dynamic>? ?? [];

            setState(() {
              for (var product in currentProducts) {
                final index = currentProducts.indexOf(product);
                final item = cartItems.firstWhere(
                      (e) => e['product'] == product['_id'],
                  orElse: () => null,
                );

                currentProducts[index]['cartQuantity'] = item != null ? item['quantity'] ?? 0 : 0;
              }
            });

            TopSnackbar.show(context, message: 'Cart updated successfully');
          }
          else if (state is AddOrRemoveCartSuccess) {
            final responseData = state.response;
            final cartItems = responseData['cart']['items'] as List<dynamic>? ?? [];

            setState(() {
              for (var product in currentProducts) {
                final index = currentProducts.indexOf(product);
                final item = cartItems.firstWhere(
                      (e) => e['product'] == product['_id'],
                  orElse: () => null,
                );

                currentProducts[index]['cartQuantity'] = item != null ? item['quantity'] ?? 0 : 0;
              }
            });

            TopSnackbar.show(context, message: 'Cart updated successfully');
          }

          // ------------------ CART ERROR STATES ------------------
          else if (state is AddToCartError) {
            TopSnackbar.show(context, message: state.message, isError: true);
          }
          else if (state is AddOrRemoveCartError) {
            TopSnackbar.show(context, message: state.message, isError: true);
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            if (selectedCategory.isNotEmpty) {
              fetchProducts(selectedCategory, page: 1);
              // Wait until products are loaded
              while (isLoadingProducts) {
                await Future.delayed(const Duration(milliseconds: 100));
              }
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // <-- added
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
            child: ParallaxFadeIn(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: SearchBarWidget(
                  //         onSearch: (query) {
                  //           setState(() {
                  //             currentPage = 1;
                  //             currentProducts.clear();
                  //           });
                  //           fetchProducts(selectedCategory, page: 1, searchQuery: query); // <-- pass query
                  //         },
                  //       ),
                  //     ),
                  //
                  //     SizedBox(width: width * 0.03),
                  //     GestureDetector(
                  //       onTap: () => Navigator.pushNamed(context, AppRoutes.notificationPage),
                  //       child: SizedBox(
                  //         height: height * 0.05,
                  //         child: Image.asset(
                  //           ImageAssets.notificationIcon,
                  //           fit: BoxFit.contain,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(height: height * 0.01),
                  Text('Categories', style: FFontStyles.titleText(18.0)),
                  SizedBox(height: height * 0.01),
                  isLoading
                      ? HomeScreenShimmer()
                      : categories.isEmpty
                      ? Center(
                    child: Text(
                      'No categories available',
                      style: FFontStyles.headingSubTitleText(14.0),
                    ),
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Horizontal scrollable categories
                      SizedBox(
                        height: height * 0.12,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                          separatorBuilder: (_, __) => SizedBox(width: width * 0.04),
                          itemBuilder: (context, index) {
                            final category = categories[index] as Map<String, dynamic>;
                            final isSelected = category['categoryname'] == selectedCategory;

                            final imagePath = ApiConstants.imageUrl + (category['categoryimage'] as String? ?? '');

                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedCategory = category['categoryname'] as String);
                                fetchProducts(selectedCategory, page: 1);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: width * 0.15,
                                    height: width * 0.15,
                                    padding: EdgeInsets.all(width * 0.003),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.categoryBorder : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor: Colors.grey.shade100,
                                            child: Container(color: Colors.white),
                                          ),
                                          Image.network(
                                            imagePath.replaceAll('\\', '/'),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                color: Colors.grey,
                                                size: 24,
                                              ),
                                            ),
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Container(); // shimmer already shown underneath
                                            },
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.005),
                                  Text(
                                    category['categoryname'] as String,
                                    style: FFontStyles.headingSubTitleText(12.0),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * 0.018),
                      Text('Products', style: FFontStyles.titleText(18.0)),
                      SizedBox(height: height * 0.015),
                      isLoadingProducts
                          ? Center(child: CircularProgressIndicator())
                          : currentProducts.isEmpty
                          ? Container(
                        margin: EdgeInsets.only(top: height * 0.15),
                        alignment: Alignment.center,
                        child: Text(
                          "Currently, there are no products available.",
                          style: FFontStyles.noAccountText(14.0),
                        ),
                      )
                          : Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: width * 0.04,
                              childAspectRatio: 0.72,
                            ),
                            itemCount: currentProducts.length,
                            itemBuilder: (context, index) {
                              final product = currentProducts[index];
                              final productImage = (product['images'] as List?)?.isNotEmpty ?? false
                                  ? ApiConstants.imageUrl +
                                  ((product['images'] as List)[0] as String).replaceAll('\\', '/')
                                  : null;

                              return ProductCard(
                                id: product['_id'],
                                title: product['productname'] as String? ?? 'Unnamed Product',
                                imagePath: productImage,
                                stockLabel: product['stock'] ?? 0,
                                onAdd: () {
                                  context.read<DashboardBloc>().add(AddToCartEventHandler(productId: product['_id']));
                                  setState(() {
                                    currentProducts.removeAt(index);
                                  });
                                },
                                onIncrement: () {
                                  context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(
                                      productId: product['_id'], action: 'increase'));
                                },
                                onDecrement: () {
                                  context.read<DashboardBloc>().add(AddOrRemoveCartEventHandler(
                                      productId: product['_id'], action: 'decrease'));
                                },
                                cartQuantity: product['cartQuantity'] ?? 0,
                                onViewCart: () {
                                  Navigator.pushNamed(context, AppRoutes.cartPage);
                                },
                              );
                            },
                          ),
                          // if (currentPage < totalPages)
                          //   Padding(
                          //     padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          //     child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.orange.shade600, // bright, noticeable color
                          //         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(12), // rounded corners
                          //         ),
                          //         elevation: 4, // subtle shadow
                          //       ),
                          //       onPressed: () => fetchProducts(selectedCategory, page: currentPage + 1),
                          //       child: Row(
                          //         mainAxisSize: MainAxisSize.min,
                          //         children: [
                          //           Icon(Icons.arrow_circle_down_sharp, color: Colors.white, size: 24),
                          //           const SizedBox(width: 8),
                          //           Text(
                          //             'Load More',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 16,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     )
                          //
                          //   ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )

      ),
    );
  }
}
