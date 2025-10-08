import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'dart:developer' as developer;

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    // ---------------- GOLD VALUE ----------------
    on<FetchGoldValueEventHandler>((event, emit) async {
      emit(GoldValueLoading());
      try {
        final url = ApiConstants.baseUrl + ApiConstants.goldPrice;
        print('url: $url');

        final res = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );
        final responseData = jsonDecode(res.body);
        print('responseData: $responseData');
        if (res.statusCode == 200 || res.statusCode == 201) {
          final data = responseData['data'];
          emit(GoldValueLoaded(data));
        } else {
          emit(GoldValueError(responseData['message'] ?? 'Failed to load gold value'));
        }
      } catch (e) {
        emit(GoldValueError(e.toString()));
      }
    });

    // ---------------- CATEGORY LIST ----------------
    on<FetchCategoryListEventHandler>((event, emit) async {
      emit(ProductListLoading());
      try {

        final token = 'Bearer ${event.token ?? Prefs.getUserToken()}';

        final body = {
          'categoryname': event.categoryName,
          'subcategoryname': event.subCategoryName,
          'minWeight': event.minWeight,
          'maxWeight': event.maxWeight,
          'purity': event.purity,
          'search': event.searchQuery,
          'limit': '1000',
        };
        final params = _filterNulls(body);
        developer.log('param: $params');

        final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.productList)
            .replace(queryParameters: params);
        developer.log('Full URL: ${uri.toString()}');


        final res = await http.get(
          uri,
          headers: {
            if (token.isNotEmpty) 'Authorization': token,
            'Accept': 'application/json',
          },
        );

        final data = jsonDecode(res.body);
        //developer.log('Full data: ${data}');

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(ProductListLoaded(data));
        } else {
          emit(ProductListError(data['message'] ?? 'Failed to load products'));
        }
      } catch (e) {
        emit(ProductListError('Oops! Something went wrong. Please try again later.'));
      }
    });


    // ---------------- CART PAGE ----------------
    on<FetchCartPageEventHandler>((event, emit) async {
      emit(CartPageLoading());
      try {

        final userId = Prefs.getUserId() ?? '';
        final url = '${ApiConstants.baseUrl}${ApiConstants.myCart}$userId';
        developer.log('cart url: $url');

        final res = await http.get(
            Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );
        developer.log('cart Items: ${res.body}');
        developer.log('cart statusCode: ${res.statusCode}');

        final data = jsonDecode(res.body);
        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(CartPageLoaded(data));
        } else if(res.statusCode == 404){
          emit(CartPageError('Your cart is empty.'));
        } else {
          emit(CartPageError(data['message'] ?? 'Failed to load cart.'));
        }
      } catch (e) {
        emit(CartPageError('Oops! Something went wrong. Please try again later.'));
      }
    });

    // ---------------- ADD TO CART ----------------
    on<AddToCartEventHandler>((event, emit) async {
      emit(AddToCartLoading());
      try {
        final body = {
          'userId' : Prefs.getUserId(),
          'productId': event.productId,
          'quantity': event.quantity,
        };
        developer.log('Add to cart url: ${ApiConstants.baseUrl + ApiConstants.addToCart}');
        developer.log('Add to cart body: $body');

        final res = await http.post(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.addToCart),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(body),
        );

        developer.log('Add to cart Response: ${res.body}');
        final data = jsonDecode(res.body);
        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(AddToCartSuccess(data));
        } else {
          emit(AddToCartError(data['message'] ?? 'Failed to add to cart'));
        }
      } catch (e) {
        emit(AddToCartError(e.toString()));
      }
    });

    // ---------------- Remove From CART ----------------
    on<RemoveFromCartEventHandler>((event, emit) async {
      emit(removeFromCartLoading(productId: event.productId));
      try {
        final body = {
          'userId' : Prefs.getUserId(),
          'productId': event.productId,
        };
        developer.log('RemoveFromCartEventHandler url: ${ApiConstants.baseUrl + ApiConstants.removeFromCart}');
        developer.log('RemoveFromCartEventHandler body: $body');

        final res = await http.delete(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.removeFromCart),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(body),
        );

        developer.log('RemoveFromCartEventHandler Response: ${res.body}');
        final data = jsonDecode(res.body);
        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(removeFromCartSuccess(data));
        } else {
          emit(removeFromCartError(data['message'] ?? 'Failed to add to cart'));
        }
      } catch (e) {
        emit(removeFromCartError('Oops! Something went wrong. Please try again later.'));
      }
    });

    // ---------------- Add or Remove From CART ----------------
    on<AddOrRemoveCartEventHandler>((event, emit) async {
      emit(AddOrRemoveFromCartLoading());
      try {
        final body = {
          'userId' : Prefs.getUserId(),
          'productId': event.productId,
          'action': event.action,
        };
        developer.log('AddOrRemoveCartEventHandler url: ${ApiConstants.baseUrl + ApiConstants.addOrRemoveCart}');
        developer.log('AddOrRemoveCartEventHandler body: $body');

        final res = await http.put(
          Uri.parse(ApiConstants.baseUrl + ApiConstants.addOrRemoveCart),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Content-Type': 'application/json'
          },
          body: jsonEncode(body),
        );

        developer.log('AddOrRemoveCartEventHandler Response: ${res.body}');
        final data = jsonDecode(res.body);
        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(AddOrRemoveCartSuccess(data));
        } else {
          emit(AddOrRemoveCartError(data['message'] ?? 'Failed to add to cart'));
        }
      } catch (e) {
        emit(AddOrRemoveCartError('Oops! Something went wrong. Please try again later.'));
      }
    });

    // ---------------- Submit CART ----------------
    on<SubmitCartEventHandler>((event, emit) async {
      emit(SubmitCartLoading());
      try {

        String url = ApiConstants.baseUrl + ApiConstants.submitCart;

        print('submit cart url: $url');
        final res = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Content-Type': 'application/json'
          },
        );

        developer.log('SubmitCart Response: ${res.body}');
        final data = jsonDecode(res.body);
        if (res.statusCode == 200 || res.statusCode == 201) {
          developer.log('SubmitCart data: $data');
          emit(SubmitCartSuccess(data));
        } else {
          emit(SubmitCartError(data['message'] ?? 'Failed to add to cart'));
        }
      } catch (e) {
        emit(SubmitCartError('Oops! Something went wrong. Please try again later.'));
      }
    });

    // ---------------- PRODUCT DETAILS ----------------
    on<FetchProductDetailsEventHandler>((event, emit) async {
      emit(ProductDetailsLoading());
      try {
        String url = ApiConstants.baseUrl + ApiConstants.productDetails + event.productId;
        developer.log('url: $url');
        final res = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
        );

        final data = jsonDecode(res.body);
        developer.log('ProductDetailsLoaded data: ${res.body}');

        if (res.statusCode == 200 || res.statusCode == 201) {
          emit(ProductDetailsLoaded(data['product'], data["cartQuantity"]));
        } else {
          emit(ProductDetailsError(data['message'] ?? 'Failed to load details'));
        }
      } catch (e) {
        developer.log(e.toString());
        emit(ProductDetailsError('Oops! Something went wrong. Please try again later.'));
      }
    });

  }

  /// Helper to remove null or empty-string values
  Map<String, String> _filterNulls(Map<String, dynamic> body) {
    final filtered = <String, String>{};
    body.forEach((k, v) {
      if (v != null) {
        filtered[k] = v.toString();
      }
    });
    return filtered;
  }
}
