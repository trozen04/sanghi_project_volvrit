import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';

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
    required this.currentImage,
    required this.additionalImages,
    required this.height,
    required this.width,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              image: DecorationImage(
                image: AssetImage(currentImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Stacked Additional Images
          Positioned(
            bottom: 10,
            left: width * 0.15,
            right: width * 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: additionalImages.map((image) => GestureDetector(
                onTap: () => onImageTap(image),
                child: Container(
                  height: width * 0.15,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.detailsImageBorder, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )).toList(),
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

  const InfoRowWidget({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

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
          Text(
            label,
            style: FFontStyles.personalInfoLabel(16),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Text(
              value,
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
  final List<String> images;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

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
                      color: status == "Pending"
                          ? AppColors.myOrdersPendingCheck.withOpacity(0.1)
                          : AppColors.myOrdersApproved.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        ImageAssets.checkIcon,
                        color: status == "Pending"
                            ? AppColors.myOrdersPendingCheck
                            : AppColors.myOrdersApproved,
                        width: height * 0.03, // adjust size as needed
                        height: height * 0.03,
                        fit: BoxFit.contain,   // ensures it fits inside without overflow
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

          SizedBox(height: height * 0.02),
          Divider(height: 0.7, color: AppColors.dividerMyOrdersCard),
          SizedBox(height: height * 0.02),

          // Images Row
          Row(
            children: images.map((img) {
              return Padding(
                padding: EdgeInsets.only(right: width * 0.03),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    img,
                    width: width * 0.18,
                    height: height * 0.08,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
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


  const OrderDetailsCard({super.key,
    required this.name,
    required this.purity,
    required this.weight,
    required this.quantity,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
        color: AppColors.cartContainerColor,
        border: Border.all(
          color: AppColors.cartContainerBorder
        ),
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width * 0.2,
              height: width * 0.2,
              child: Image.asset(ImageAssets.RingImage),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: FFontStyles.cartTitle(16),
                  ),
                  SizedBox(height: height * 0.005),
                  CartInfoRow(label: 'Purity -', value: purity),
                  CartInfoRow(label: 'Weight -', value: weight),
                  CartInfoRow(label: 'Quantity -', value: quantity),
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

  NotificationCard({
    required this.title,
    required this.date,
    required this.time,
    this.description,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      decoration: BoxDecoration(
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
            // Animate title + icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: FFontStyles.notificationCardLabel(16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: width * 0.05),
                  onPressed: () {},
                ),
              ],
            ),

            SizedBox(height: height * 0.01),

            // Animate date & time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: FFontStyles.notificationDate(12),
                ),
                Text(
                  time,
                  style: FFontStyles.notificationTime(10),
                ),
              ],
            ),

            // Animate description if exists
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
    );
  }
}
