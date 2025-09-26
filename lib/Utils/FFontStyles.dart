import 'package:flutter/material.dart';
import 'AppColors.dart';

class FFontStyles {
  static const String InterRegular = 'InterRegular';
  static const String InterSemiBold = 'InterSemiBold';
  static const String InterMedium = 'InterMedium';
  static const String RobotoRegular = 'RobotoRegular';
  static const String RobotoMedium = 'RobotoMedium';
  static const String BookantiquaBold = 'BookantiquaBold';

  static TextStyle heading(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.loginTextTheme,
    fontWeight: FontWeight.w600,
  );
  static TextStyle addtoCard(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.loginTextTheme,
    fontWeight: FontWeight.w600,
  );

  static TextStyle subtitle(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.loginSubtitle,
    fontWeight: FontWeight.w400
  );

  static TextStyle hintText(double size) => TextStyle(
    fontFamily: RobotoRegular,
    fontSize: size,
    color: AppColors.hintColor,
    fontWeight: FontWeight.w400
  );

  static TextStyle noAccountText(double size) => TextStyle(
    fontFamily: RobotoRegular,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400
  );

  static TextStyle personalInfoLabel(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w400
  );
  static TextStyle searchHistory(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.searchHistory,
    fontWeight: FontWeight.w400
  );

  static TextStyle liveText(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500
  );
  static TextStyle headingSubTitleText(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600
  );
  static TextStyle customAppBarTitleText(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600
  );
  static TextStyle searchHeading(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.searchHeading,
    fontWeight: FontWeight.w600
  );

  static TextStyle emailLabel(double size) => TextStyle(
    fontFamily: RobotoMedium,
    fontSize: size,
    color: AppColors.labelColor,
    fontWeight: FontWeight.w500
  );
  static TextStyle editProfileLabel(double size) => TextStyle(
    fontFamily: RobotoMedium,
    fontSize: size,
    color: AppColors.editProfileLabelColor,
    fontWeight: FontWeight.w500
  );

  static TextStyle button(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.background,
    fontWeight: FontWeight.w600,
  );

  static TextStyle link(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );
  static TextStyle cartContainerNormal(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.cartContainerNormal,
    fontWeight: FontWeight.w500,
  );
  static TextStyle cartLabel(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.cartContainerNormal,
    fontWeight: FontWeight.w400,
  );
  static TextStyle stockLeft(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.primary,
    fontWeight: FontWeight.w400,
  );

    static TextStyle filters(double size) => TextStyle(
    fontFamily: InterMedium,
    fontSize: size,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );
  static TextStyle cartTitle(double size) => TextStyle(
    fontFamily: InterMedium,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w500,
  );

  static TextStyle profileCardLable(double size) => TextStyle(
    fontFamily: InterMedium,
    fontSize: size,
    color: AppColors.profileCardLable,
    fontWeight: FontWeight.w500,
  );
  static TextStyle myOrdersStatus(double size) => TextStyle(
    fontFamily: InterMedium,
    fontSize: size,
    color: AppColors.myOrdersApproved,
    fontWeight: FontWeight.w500,
  );

  static TextStyle detailsCardLabel(double size) => TextStyle(
    fontFamily: InterMedium,
    fontSize: size,
    color: AppColors.profileCardLable,
    fontWeight: FontWeight.w500,
  );
  static TextStyle notificationCardLabel(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.profileCardLable,
    fontWeight: FontWeight.w600,
  );

  static TextStyle detailsCardValue(double size) => TextStyle(
    fontFamily: BookantiquaBold,
    fontSize: size,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
  );

  static TextStyle caratPrice(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );
    static TextStyle quantity(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.primary,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleText(double size) => TextStyle(
    fontFamily: InterSemiBold,
    fontSize: size,
    color: AppColors.titleTextColor,
    fontWeight: FontWeight.w600,
  );
  static TextStyle notificationDate(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.notificationDate,
    fontWeight: FontWeight.w400,
  );
  static TextStyle notificationTime(double size) => TextStyle(
    fontFamily: InterRegular,
    fontSize: size,
    color: AppColors.notificationTimeAgo,
    fontWeight: FontWeight.w400,
  );

}
