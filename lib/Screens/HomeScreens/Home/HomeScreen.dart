import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/DashboardBloc/dashboard_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/ProductCard.dart';
import 'package:gold_project/Widgets/AppBar/custom_appbar_home.dart';
import 'package:gold_project/Widgets/SearchBarWidget.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = ['Earrings', 'Necklace', 'Rings', 'Bangles', 'Chains'];
  String selectedCategory = 'Earrings';
  final Map<String, String> categoryImages = {
    'Earrings': ImageAssets.EarringImage,
    'Necklace': ImageAssets.EarringImage,
    'Rings': ImageAssets.EarringImage,
    'Bangles': ImageAssets.EarringImage,
    'Chains': ImageAssets.EarringImage,
  };
  final Map<String, List<Map<String, dynamic>>> productsByCategory = {
    'Earrings': [
      {'title': 'Gold Earrings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Earrings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Earrings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Earrings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Earrings', 'image': ImageAssets.RingImage, 'stock': 2},
    ],
    'Necklace': [
      {'title': 'Gold Necklace', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Necklace', 'image': ImageAssets.RingImage, 'stock': 2},
    ],
    'Rings': [
      {'title': 'Gold Rings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Gold Rings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Gold Rings', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Gold Rings', 'image': ImageAssets.RingImage, 'stock': 2},
    ],
    'Bangles': [
      {'title': 'Gold Bangle', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Gold Bangle', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Bangle', 'image': ImageAssets.RingImage, 'stock': 2},
    ],
    'Chains': [
      {'title': 'Gold Chain', 'image': ImageAssets.RingImage, 'stock': 2},
      {'title': 'Silver Chain', 'image': ImageAssets.RingImage, 'stock': 2},
    ],
  };
  bool isLoading = false;
  String? token = '';

  @override
  void initState() {
    super.initState();
    print('token = $token');
    fetchToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(FetchGoldValueEventHandler());
    });
  }

  void fetchToken() async {
    token = await Prefs.getUserToken();
    print('token = $token');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final currentProducts = productsByCategory[selectedCategory] ?? [];

    return Scaffold(
      appBar: CustomAppBarHome(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.015),
        child: ParallaxFadeIn(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SearchBarWidget()),
                  SizedBox(width: width * 0.03),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.notificationPage),
                    child: SizedBox(
                      height: height * 0.05,
                      child: Image.asset(
                        ImageAssets.notificationIcon,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Text('Categories', style: FFontStyles.titleText(18.0), ),
              SizedBox(height: height * 0.01),
              isLoading
                  ? HomeScreenShimmer()
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Horizontal scrollable categories
                  SizedBox(
                    height: height * 0.12, // enough to fit circle + label
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.02), // horizontal padding
                      separatorBuilder: (_, __) => SizedBox(width: width * 0.04),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;

                        // Safe image lookup with fallback
                        final imagePath = categoryImages[category] ?? ImageAssets.RingImage;

                        return GestureDetector(
                          onTap: () => setState(() => selectedCategory = category),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width * 0.15, // circle width
                                height: width * 0.15, // circle height
                                padding: EdgeInsets.all(width * 0.003),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.categoryBorder : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.005),
                              Text(category, style: FFontStyles.headingSubTitleText(12.0), overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.025),

                  Text('Products', style: FFontStyles.titleText(18.0), textAlign: TextAlign.left,),
                  SizedBox(height: height * 0.015),
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
                      return ProductCard(
                        title: product['title'],
                        imagePath: product['image'],
                        stockLabel: '${product['stock']} Stock Left',
                        onAdd: () {
                          TopSnackbar.show(
                            context,
                            message: 'This feature is disabled.',
                            isError: true
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}