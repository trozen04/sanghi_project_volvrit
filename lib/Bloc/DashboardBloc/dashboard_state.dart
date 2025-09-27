part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

// ----- GOLD VALUE -----
final class GoldValueLoading extends DashboardState {}
final class GoldValueLoaded extends DashboardState {
  final goldData;
  GoldValueLoaded(this.goldData);
}
final class GoldValueError extends DashboardState {
  final String message;
  GoldValueError(this.message);
}

// ----- CATEGORY LIST -----
final class CategoryListLoading extends DashboardState {}
final class CategoryListLoaded extends DashboardState {
  final List<dynamic> categories;
  CategoryListLoaded(this.categories);
}
final class CategoryListError extends DashboardState {
  final String message;
  CategoryListError(this.message);
}

// ----- PRODUCT LIST -----
final class ProductListLoading extends DashboardState {}
final class ProductListLoaded extends DashboardState {
  final List<dynamic> products;
  ProductListLoaded(this.products);
}
final class ProductListError extends DashboardState {
  final String message;
  ProductListError(this.message);
}

// ----- CART PAGE -----
final class CartPageLoading extends DashboardState {}
final class CartPageLoaded extends DashboardState {
  final Map<String, dynamic> cart;
  CartPageLoaded(this.cart);
}
final class CartPageError extends DashboardState {
  final String message;
  CartPageError(this.message);
}

// ----- ADD TO CART -----
final class AddToCartLoading extends DashboardState {}
final class AddToCartSuccess extends DashboardState {
  final Map<String, dynamic> response;
  AddToCartSuccess(this.response);
}
final class AddToCartError extends DashboardState {
  final String message;
  AddToCartError(this.message);
}

// ----- PRODUCT DETAILS -----
final class ProductDetailsLoading extends DashboardState {}
final class ProductDetailsLoaded extends DashboardState {
  final Map<String, dynamic> product;
  ProductDetailsLoaded(this.product);
}
final class ProductDetailsError extends DashboardState {
  final String message;
  ProductDetailsError(this.message);
}
