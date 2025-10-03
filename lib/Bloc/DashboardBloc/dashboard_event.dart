part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

/// Fetch current gold value
final class FetchGoldValueEventHandler extends DashboardEvent {}

/// Fetch category list
final class FetchCategoryListEventHandler extends DashboardEvent {
  String token;
  String? categoryName;
  String? subCategoryName;
  int? page;
  String? minWeight;
  String? maxWeight;
  String? purity;
  FetchCategoryListEventHandler(
      {required this.token,
        this.categoryName,
        this.subCategoryName,
        this.page,
        this.minWeight,
        this.maxWeight,
        this.purity
      });
}

/// Fetch cart page details
final class FetchCartPageEventHandler extends DashboardEvent {}

/// Add a product to cart
final class AddToCartEventHandler extends DashboardEvent {
  final String productId;
  final int quantity;
  AddToCartEventHandler({required this.productId, this.quantity = 1});
}

/// RemoveCartEventHandler product to cart

final class RemoveFromCartEventHandler extends DashboardEvent {
  final String productId;
  RemoveFromCartEventHandler({required this.productId});
}

/// AddOrRemoveCartEventHandler product to cart
final class AddOrRemoveCartEventHandler extends DashboardEvent {
  final String productId;
  final String action;
  AddOrRemoveCartEventHandler({required this.productId, required this.action});
}


///SubmitCartEventHandler product to cart
final class SubmitCartEventHandler extends DashboardEvent {}

/// Fetch single product detail
final class FetchProductDetailsEventHandler extends DashboardEvent {
  final String productId;
  FetchProductDetailsEventHandler({required this.productId});
}
