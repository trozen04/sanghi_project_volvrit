part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

/// Fetch current gold value
final class FetchGoldValueEventHandler extends DashboardEvent {}

/// Fetch category list
final class FetchCategoryListEventHandler extends DashboardEvent {}

/// Fetch product list
final class FetchProductListEventHandler extends DashboardEvent {}

/// Fetch cart page details
final class FetchCartPageEventHandler extends DashboardEvent {}

/// Add a product to cart
final class AddToCartEventHandler extends DashboardEvent {
  final int productId;
  final int quantity;
  AddToCartEventHandler({required this.productId, this.quantity = 1});
}

/// Fetch single product details
final class FetchProductDetailsEventHandler extends DashboardEvent {
  final int productId;
  FetchProductDetailsEventHandler({required this.productId});
}
