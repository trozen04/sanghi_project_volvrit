part of 'my_orders_bloc.dart';

@immutable
sealed class MyOrdersEvent {}

/// Fetch all orders (with optional status filter)
final class FetchOrdersEventHandler extends MyOrdersEvent {
  final String? action; // "pending" or "approved"
  final int page;

  FetchOrdersEventHandler({this.action, this.page = 1});
}

/// Fetch a single order’s details
final class FetchOrderDetailsEventHandler extends MyOrdersEvent {
  final String orderId;
  final int page;

  FetchOrderDetailsEventHandler({
    required this.orderId,
    this.page = 1,
  });
}

