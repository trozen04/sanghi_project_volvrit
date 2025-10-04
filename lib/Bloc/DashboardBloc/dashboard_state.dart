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

// ----- PRODUCT LIST -----
final class ProductListLoading extends DashboardState {}
final class ProductListLoaded extends DashboardState {
  var responseData;
  ProductListLoaded(this.responseData);
}
final class ProductListError extends DashboardState {
  final String message;
  ProductListError(this.message);
}

// ----- CART PAGE -----
final class CartPageLoading extends DashboardState {}
final class CartPageLoaded extends DashboardState {
  final cartData;
  CartPageLoaded(this.cartData);
}
final class CartPageError extends DashboardState {
  final String message;
  CartPageError(this.message);
}

// ----- ADD TO CART -----
final class AddToCartLoading extends DashboardState {}
final class AddToCartSuccess extends DashboardState {
  final response;
  AddToCartSuccess(this.response);
}
final class AddToCartError extends DashboardState {
  final String message;
  AddToCartError(this.message);
}

final class removeFromCartLoading extends DashboardState {}
final class removeFromCartSuccess extends DashboardState {
  final response;
  removeFromCartSuccess(this.response);
}
final class removeFromCartError extends DashboardState {
  final String message;
  removeFromCartError(this.message);
}

//Add OR Remove From Cart
final class AddOrRemoveFromCartLoading extends DashboardState {}
final class AddOrRemoveCartSuccess extends DashboardState {
  final response;
  AddOrRemoveCartSuccess(this.response);
}
final class AddOrRemoveCartError extends DashboardState {
  final String message;
  AddOrRemoveCartError(this.message);
}
//Submit From Cart
final class SubmitCartLoading extends DashboardState {}
final class SubmitCartSuccess extends DashboardState {
  final response;
  SubmitCartSuccess(this.response);
}
final class SubmitCartError extends DashboardState {
  final String message;
  SubmitCartError(this.message);
}

// ----- PRODUCT DETAILS -----
final class ProductDetailsLoading extends DashboardState {}
final class ProductDetailsLoaded extends DashboardState {
  final product;
  int quantity;
  ProductDetailsLoaded(this.product, this.quantity);
}
final class ProductDetailsError extends DashboardState {
  final String message;
  ProductDetailsError(this.message);
}
