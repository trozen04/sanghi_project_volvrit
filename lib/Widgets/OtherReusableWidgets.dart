import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/date_utils.dart';
import 'package:shimmer/shimmer.dart';

/// Reusable widget for Purity/Weight row
class CartInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const CartInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: FFontStyles.cartTitle(12), overflow: TextOverflow.ellipsis,),
          Text(value, style: FFontStyles.cartContainerNormal(12), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class cartPageRow extends StatelessWidget {
  final String label;
  final String value;

  const cartPageRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: FFontStyles.cartLabel(14), overflow: TextOverflow.ellipsis,),
          Text(value, style: FFontStyles.cartTitle(16), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class DetailsPageRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailsPageRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: FFontStyles.detailsCardLabel(14), overflow: TextOverflow.ellipsis,),
          Text(value, style: FFontStyles.detailsCardValue(20), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

//Profile Page
class ProfileCard extends StatelessWidget {
  final String? imagePath; // optional image for left side
  final String title;
  final VoidCallback onTap;
  final Color? iconColor; // optional for right CircleIcon

  const ProfileCard({
    super.key,
    this.imagePath,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (imagePath != null)
                  Image.asset(
                    imagePath!,
                    width: width * 0.12,
                    height: width * 0.12,
                  ),
                if (imagePath != null) SizedBox(width: width * 0.04),
                Text(
                  title,
                  style: iconColor != null
                      ? FFontStyles.profileCardLable(16).copyWith(color: iconColor)
                      : FFontStyles.profileCardLable(16),
                ),
              ],
            ),
            CircleIcon(
              icon: Icons.chevron_right,
              size: 40,
              backgroundColor: iconColor,
              iconColor: iconColor,
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;

  const CircleIcon({
    super.key,
    required this.icon,
    required this.size,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: iconColor?.withOpacity(0.1) ?? AppColors.circleBGColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          color: iconColor ?? AppColors.circleIconColor, // default if null
          size: size * 0.6,
        ),
      ),
    );
  }
}

//For Details Page
class ImageStackWidget extends StatelessWidget {
  final String currentImage;
  final List<String> additionalImages;
  final double height;
  final double width;
  final Function(String) onImageTap;

  const ImageStackWidget({
    super.key,
    required this.currentImage,
    required this.additionalImages,
    required this.height,
    required this.width,
    required this.onImageTap,
  });

  Widget _buildNetworkImage(String url, {BoxFit fit = BoxFit.cover}) {
    return Image.network(
      ApiConstants.imageUrl + url,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    developer.log('imagees: $additionalImages \n $currentImage');
    return SizedBox(
      height: height * 0.3,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main Image
          Container(
            height: height * 0.3,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildNetworkImage(currentImage, fit: BoxFit.fill),
          ),

          // Thumbnails
          if (additionalImages.isNotEmpty)
            Positioned(
              bottom: 10,
              left: width * 0.15,
              right: width * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: additionalImages.map((image) {
                  return GestureDetector(
                    onTap: () => onImageTap(image),
                    child: Container(
                      height: width * 0.15,
                      width: width * 0.15,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.detailsImageBorder,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildNetworkImage(image, fit: BoxFit.fill),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

//For Personal Info page
class InfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool? isLast;
  final bool? isGst; // optional flag to indicate GST validation

  const InfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
    this.isGst = false,
  });

  // GST validation function
  bool _isValidGst(String gst) {
    final gstRegex = RegExp(
        r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstRegex.hasMatch(gst.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    String displayValue = value;

    // Apply GST validation if needed
    if (isGst == true && value.isNotEmpty) {
      displayValue = _isValidGst(value) ? value : 'Invalid GST';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: height * 0.02),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.profileInfoBorder,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: FFontStyles.personalInfoLabel(16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: Text(
              displayValue,
              textAlign: TextAlign.end,
              style: FFontStyles.cartLabel(14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

//For Order Page
class OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final String status;
  final Color statusColor;
  final List<String> images; // network image URLs

  const OrderCard({
    super.key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    final hasImages = images.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: AppColors.cartContainerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cartContainerBorder),
      ),
      child: StaggeredReveal(
        initialDelay: const Duration(milliseconds: 80),
        duration: const Duration(milliseconds: 900),
        staggerFraction: 0.18,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: height * 0.05,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      color: status.toLowerCase() == "pending"
                          ? AppColors.myOrdersPendingCheck.withOpacity(0.1)
                          : AppColors.myOrdersApproved.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageAssets.checkIcon,
                        color: status.toLowerCase() == "pending"
                            ? AppColors.myOrdersPendingCheck
                            : AppColors.myOrdersApproved,
                        width: height * 0.03,
                        height: height * 0.03,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$orderId',
                        style: FFontStyles.cartTitle(12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        date,
                        style: FFontStyles.cartTitle(14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: height * 0.006,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: FFontStyles.myOrdersStatus(14).copyWith(
                    color: statusColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          if (hasImages) ...[
            SizedBox(height: height * 0.02),
            Divider(height: 0.7, color: AppColors.dividerMyOrdersCard),
            SizedBox(height: height * 0.02),

            // Scrollable Images
            SizedBox(
              height: height * 0.06,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => SizedBox(width: width * 0.03),
                itemBuilder: (context, index) {
                  final imgUrl = images[index].replaceAll("\\", "/");
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      ApiConstants.imageUrl + imgUrl,
                      width: height * 0.06,
                      height: height * 0.06,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: height * 0.06,
                            height: height * 0.06,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: height * 0.06,
                          height: height * 0.06,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}


//Order Details Page

class OrderDetailsCard extends StatelessWidget {
  final String name;
  final String purity;
  final String weight;
  final String quantity;
  final double height;
  final double width;
  final String? imagePath; // optional

  const OrderDetailsCard({
    super.key,
    required this.name,
    required this.purity,
    required this.weight,
    required this.quantity,
    required this.height,
    required this.width,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.03),
      decoration: BoxDecoration(
        color: AppColors.cartContainerColor,
        border: Border.all(color: AppColors.cartContainerBorder),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.2,
              height: width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imagePath != null
                    ? Image.network(
                  imagePath!,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        color: Colors.grey.shade200,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    );
                  },
                )
                    : Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: FFontStyles.cartTitle(16), overflow: TextOverflow.ellipsis,),
                  SizedBox(height: height * 0.005),
                  CartInfoRow(label: 'Purity -', value: formatPurity(purity)),
                  CartInfoRow(label: 'Weight -', value: formatWeight(weight)),
                  CartInfoRow(label: 'Quantity -', value: '$quantity Qty'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Notification card
class NotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String? description;
  final double height;
  final double width;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const NotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    this.description,
    required this.height,
    required this.width,
    required this.isRead,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isRead ? 0.7 : 1.0, // visual cue for read notifications
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: height * 0.02),
          decoration: BoxDecoration(
            color: isRead ? Colors.white : Colors.blue.shade50,
            border: Border.all(color: AppColors.notificationCardBorderColor),
            borderRadius: BorderRadius.circular(width * 0.02),
          ),
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: StaggeredReveal(
              initialDelay: const Duration(milliseconds: 80),
              duration: const Duration(milliseconds: 900),
              staggerFraction: 0.18,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: FFontStyles.notificationCardLabel(16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Image.asset(
                        ImageAssets.closeIcon,
                        width: width * 0.05,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatNotificationDate(date),
                      style: FFontStyles.notificationDate(12),
                    ),
                    Text(
                      time,
                      style: FFontStyles.notificationTime(10),
                    ),
                  ],
                ),
                if (description != null) ...[
                  SizedBox(height: height * 0.01),
                  Text(
                    description!,
                    style: FFontStyles.notificationTime(12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String formatPurity(String? purity) {
  if (purity == null || purity.isEmpty) return '-';
  final number = int.tryParse(purity.replaceAll(RegExp(r'[^0-9]'), ''));
  return number != null ? '$number carat' : '-';
}

String formatWeight(String? weight) {
  if (weight == null || weight.isEmpty) return '-';
  final number = double.tryParse(weight.replaceAll(RegExp(r'[^0-9.]'), ''));
  return number != null ? '${number.toStringAsFixed(0)}g' : '-';
}

