part of 'my_orders_bloc.dart';

@immutable
sealed class MyOrdersState {}

final class MyOrdersInitial extends MyOrdersState {}

/// ----- ORDERS LIST -----
final class OrdersLoading extends MyOrdersState {}
final class OrdersLoaded extends MyOrdersState {
  final List<Map<String, dynamic>> orders;
  OrdersLoaded(this.orders);
}
final class OrdersError extends MyOrdersState {
  final String message;
  OrdersError(this.message);
}

/// ----- ORDER DETAILS -----
final class OrderDetailsLoading extends MyOrdersState {}
final class OrderDetailsLoaded extends MyOrdersState {
  final Map<String, dynamic> order;
  OrderDetailsLoaded(this.order);
}
final class OrderDetailsError extends MyOrdersState {
  final String message;
  OrderDetailsError(this.message);
}
