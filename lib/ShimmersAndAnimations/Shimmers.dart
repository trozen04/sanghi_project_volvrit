import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gold_project/Utils/AppColors.dart';

class DetailsPageShimmer extends StatelessWidget {
  const DetailsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Image Placeholder
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: height * 0.35,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Additional Images Placeholder
              SizedBox(
                height: height * 0.08,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(width: width * 0.02),
                  itemBuilder: (_, index) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: height * 0.08,
                      height: height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Title and Stock Placeholder
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: width * 0.6,
                      height: height * 0.025,
                      color: Colors.grey,
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: width * 0.25,
                      height: height * 0.025,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),

              // Description Placeholder
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(3, (_) => Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.005),
                    child: Container(
                      width: double.infinity,
                      height: height * 0.015,
                      color: Colors.grey,
                    ),
                  )),
                ),
              ),
              SizedBox(height: height * 0.02),

              // Details Card Placeholder
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: List.generate(2, (_) => Padding(
                      padding: EdgeInsets.symmetric(vertical: height * 0.01),
                      child: Container(
                        height: height * 0.02,
                        width: double.infinity,
                        color: Colors.grey,
                      ),
                    )),
                  ),
                ),
              ),
              SizedBox(height: height * 0.1), // Space for FAB placeholder
            ],
          ),
        ),
      ),
    );
  }
}

class CartPageShimmer extends StatelessWidget {
  const CartPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: Column(
          children: [
            // Cart Items Placeholder
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => SizedBox(height: height * 0.02),
                itemBuilder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: height * 0.12,
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: height * 0.09,
                          height: height * 0.09,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.015,
                                width: width * 0.4,
                                color: Colors.grey,
                              ),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: height * 0.015,
                                width: width * 0.25,
                                color: Colors.grey,
                              ),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: height * 0.015,
                                width: width * 0.15,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.02),

            // Total Section Placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: height * 0.02,
                    width: width * 0.3,
                    color: Colors.grey,
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    height: height * 0.02,
                    width: width * 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(height: height * 0.01),
                  Container(
                    height: height * 0.02,
                    width: width * 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(height: height * 0.02),
                  Container(
                    height: height * 0.05,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScreenShimmer extends StatelessWidget {
  const CategoryScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Buttons Row Placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Button
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: width * 0.25,
                    height: height * 0.04,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Filter & Sort Buttons
                Row(
                  children: List.generate(2, (_) => Padding(
                    padding: EdgeInsets.only(right: width * 0.02),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: width * 0.25,
                        height: height * 0.04,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  )),
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            // Section Title Placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: width * 0.4,
                height: height * 0.025,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: height * 0.015),

            // Grid of Product Cards Placeholder
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
                itemBuilder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Categories row placeholders
        SizedBox(
          height: height * 0.12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
                  (_) => Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Container(
                      width: height * 0.08,
                      height: height * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: height * 0.08,
                      height: height * 0.015,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.03),

        // Products title
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: width * 0.3,
            height: height * 0.02,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: height * 0.015),

        // Grid of product placeholders
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: width * 0.04,
            mainAxisSpacing: height * 0.02,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyOrdersPageShimmer extends StatelessWidget {
  const MyOrdersPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: Column(
          children: [
            // Tabs Placeholder
            Container(
              height: height * 0.06,
              decoration: BoxDecoration(
                color: AppColors.tabBackground,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: List.generate(2, (_) => Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.005),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                )),
              ),
            ),

            SizedBox(height: height * 0.03),

            // Orders List Placeholder
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => SizedBox(height: height * 0.02),
                itemBuilder: (_, __) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: height * 0.12,
                    padding: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        // Image stack placeholder
                        Container(
                          width: height * 0.08,
                          height: height * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(width: width * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: height * 0.015,
                                width: width * 0.4,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: height * 0.015,
                                width: width * 0.25,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: height * 0.01),
                              Container(
                                height: height * 0.015,
                                width: width * 0.15,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyOrderDetailsPageShimmer extends StatelessWidget {
  const MyOrderDetailsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.008),
        itemCount: 2, // number of orders to show placeholder
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: height * 0.02),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width * 0.2,
                          height: height * 0.015,
                          color: Colors.grey,
                        ),
                        SizedBox(height: height * 0.005),
                        Container(
                          width: width * 0.35,
                          height: height * 0.02,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Container(
                      width: width * 0.2,
                      height: height * 0.025,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.02),

                // Order items placeholders
                Column(
                  children: List.generate(3, (_) => Padding(
                    padding: EdgeInsets.only(bottom: height * 0.015),
                    child: Container(
                      padding: EdgeInsets.all(width * 0.03),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // Image placeholder
                          Container(
                            width: height * 0.08,
                            height: height * 0.08,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(width: width * 0.03),
                          // Text placeholders
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: width * 0.4,
                                  height: height * 0.015,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: height * 0.005),
                                Container(
                                  width: width * 0.25,
                                  height: height * 0.015,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(height: height * 0.005),
                                Container(
                                  width: width * 0.2,
                                  height: height * 0.015,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationPageShimmer extends StatelessWidget {
  const NotificationPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        itemCount: 6, // number of shimmer notifications
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: height * 0.02),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: width * 0.6,
                    height: height * 0.02,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: height * 0.008),
                  // Date & Time placeholder
                  Row(
                    children: [
                      Container(
                        width: width * 0.25,
                        height: height * 0.015,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(width: width * 0.03),
                      Container(
                        width: width * 0.2,
                        height: height * 0.015,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.01),
                  // Description placeholder (optional)
                  Container(
                    width: double.infinity,
                    height: height * 0.04,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalInfoPageShimmer extends StatelessWidget {
  const PersonalInfoPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Shimmer rows
            ...List.generate(6, (index) => Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.25,
                        height: height * 0.02,
                        color: Colors.grey.shade400,
                      ),
                      Spacer(),
                      Container(
                        width: width * 0.4,
                        height: height * 0.02,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            )),

            SizedBox(height: height * 0.03),

            // Edit Profile button shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.015, horizontal: width * 0.04),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: height * 0.025,
                      height: height * 0.025,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(width: width * 0.02),
                    Container(
                      width: width * 0.3,
                      height: height * 0.02,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfilePageShimmer extends StatelessWidget {
  const EditProfilePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    Widget shimmerBox({double? w, double? h, BorderRadius? radius}) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: w ?? width,
          height: h ?? height * 0.05,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: radius ?? BorderRadius.circular(10),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name label + field
          shimmerBox(w: width * 0.25, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.02),

          // Phone Number label + field
          shimmerBox(w: width * 0.35, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.02),

          // Business Name label + field
          shimmerBox(w: width * 0.4, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.02),

          // GST Number label + field
          shimmerBox(w: width * 0.25, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.02),

          // Address label + field
          shimmerBox(w: width * 0.3, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.02),

          // Email label + field
          shimmerBox(w: width * 0.2, h: height * 0.02, radius: BorderRadius.circular(4)),
          SizedBox(height: height * 0.01),
          shimmerBox(),
          SizedBox(height: height * 0.03),

          // Save Button
          shimmerBox(h: height * 0.055, radius: BorderRadius.circular(30)),
        ],
      ),
    );
  }
}


class ProductCardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const ProductCardShimmer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

