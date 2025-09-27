import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

part 'my_orders_event.dart';
part 'my_orders_state.dart';

class MyOrdersBloc extends Bloc<MyOrdersEvent, MyOrdersState> {
  MyOrdersBloc() : super(MyOrdersInitial()) {

    // Fetch all orders
    on<FetchOrdersEventHandler>((event, emit) async {
      emit(OrdersLoading());
      try {
        // Optional query parameters
        final params = <String, String>{
          if (event.status != null && event.status!.trim().isNotEmpty) 'status': event.status!,
          // 'user_id': Prefs.getUserId(), // optional
        };

        final url = '${ApiConstants.baseUrl}';
        final uri = Uri.parse(url).replace(queryParameters: params);

        developer.log('Fetching orders: $uri');

        final res = await http.get(uri);
        developer.log('Response: ${res.body}');

        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(OrdersLoaded(responseData['orders'] ?? []));
        } else {
          emit(OrdersError(responseData['message'] ?? 'Failed to fetch orders'));
        }
      } catch (e) {
        emit(OrdersError(e.toString()));
      }
    });

    // Fetch single order details
    on<FetchOrderDetailsEventHandler>((event, emit) async {
      emit(OrderDetailsLoading());
      try {
        final url = '${ApiConstants.baseUrl}/${event.orderId}';
        developer.log('Fetching order details: $url');

        final res = await http.get(Uri.parse(url));
        developer.log('Response: ${res.body}');

        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200) {
          emit(OrderDetailsLoaded(responseData));
        } else {
          emit(OrderDetailsError(responseData['message'] ?? 'Failed to fetch order details'));
        }
      } catch (e) {
        emit(OrderDetailsError(e.toString()));
      }
    });

  }
}
