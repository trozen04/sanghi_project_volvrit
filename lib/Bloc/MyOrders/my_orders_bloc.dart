import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
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
        final params = <String, String>{
          'limit': '10', // pagination limit
          'page': event.page.toString(),
          if (event.action != null && event.action!.trim().isNotEmpty)
            'status': event.action!,
        };

        final url = '${ApiConstants.baseUrl}${ApiConstants.myOrders}';
        final uri = Uri.parse(url).replace(queryParameters: params);

        developer.log('Fetching orders: $uri');

        final res = await http.get(uri,
            headers: {
          'Authorization': 'Bearer ${Prefs.getUserToken()}',
          'Accept': 'application/json',
        }
        );

        developer.log('Response: ${res.body}');

        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          final data = responseData['data'] ?? [];
          final pagination = responseData['pagination'] ?? {};
          final currentPage = pagination['page'] ?? 1;
          final totalPages = pagination['totalPages'] ?? 1;

          emit(OrdersLoaded(data));

          developer.log('Page $currentPage / $totalPages');

          // In widget, you can check:
          // hasMore = currentPage < totalPages
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
        final params = <String, dynamic>{
          'page': event.page,
        };

        final url = '${ApiConstants.baseUrl}${ApiConstants.myOrders}${event.orderId}/user';
        final uri = Uri.parse(url);

        developer.log('Fetching myOrderDetails: $uri');

        final res = await http.get(
            uri,
            headers: {
              'Authorization': 'Bearer ${Prefs.getUserToken()}',
              'Accept': 'application/json',
            }
        );


        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(OrderDetailsLoaded(responseData['data']));
        } else {
          emit(OrderDetailsError(responseData['message'] ?? 'Failed to fetch order details'));
        }
      } catch (e) {
        emit(OrderDetailsError(e.toString()));
      }
    });

  }
}
