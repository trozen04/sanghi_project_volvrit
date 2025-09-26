import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitial()) {
    on<FetchOrdersEventHandler>(_onFetchOrders);
    on<FetchOrderDetailsEventHandler>(_onFetchOrderDetails);
  }

  /// Remove null/empty values from body map
  Map<String, dynamic> _filterNulls(Map<String, dynamic> data) {
    final filtered = <String, dynamic>{};
    data.forEach((key, value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        filtered[key] = value;
      }
    });
    return filtered;
  }

  /// Fetch all orders
  Future<void> _onFetchOrders(
      FetchOrdersEventHandler event, Emitter<MyOrdersState> emit) async {
    emit(OrdersLoading());
    try {
      final body = {
        'status': event.status,
        // 'user_id': '123', // example optional param
      };
      final params = _filterNulls(body);

      final res = await http.get(
        Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        emit(OrdersLoaded(data['orders'] ?? []));
      } else {
        emit(OrdersError(data['message'] ?? 'Failed to fetch orders'));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  /// Fetch a single order’s details
  Future<void> _onFetchOrderDetails(
      FetchOrderDetailsEventHandler event, Emitter<MyOrdersState> emit) async {
    emit(OrderDetailsLoading());
    try {
      final body = {
        'order_id': event.orderId,
        // 'include_items': true, // optional example
      };
      final params = _filterNulls(body);

      final res = await http.get(
        Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        emit(OrderDetailsLoaded(data));
      } else {
        emit(OrderDetailsError(data['message'] ?? 'Failed to fetch order details'));
      }
    } catch (e) {
      emit(OrderDetailsError(e.toString()));
    }
  }
}
