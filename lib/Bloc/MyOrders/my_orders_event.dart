part of 'my_orders_bloc.dart';

@immutable
sealed class MyOrdersEvent {}

/// Fetch all orders (with optional status filter)
final class FetchOrdersEventHandler extends MyOrdersEvent {
  final String? status; // e.g., "Pending" or "Approved"
  FetchOrdersEventHandler({this.status});
}

/// Fetch a single order’s details
final class FetchOrderDetailsEventHandler extends MyOrdersEvent {
  final String orderId;
  FetchOrderDetailsEventHandler({required this.orderId});
}
