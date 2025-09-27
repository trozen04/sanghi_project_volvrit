import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
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
        // body (example optional params)
        // final body = {
        //   'currency': 'INR',
        //   'date': null,
        // };
        // final params = _filterNulls(body);

        final url = ApiConstants.baseUrl + ApiConstants.goldPrice;
        developer.log('url: $url');

        final res = await http.get(
         // Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
          Uri.parse(url),
        );
        final responseData = jsonDecode(res.body);
        developer.log('data: $responseData');
        if (res.statusCode == 200) {
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
      emit(CategoryListLoading());
      try {
        final body = {
          'parent_id': 10,
          'lang': '',
        };
        final params = _filterNulls(body);

        final res = await http.get(
          Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
        );

        final data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          emit(CategoryListLoaded(data['categories']));
        } else {
          emit(CategoryListError(data['message'] ?? 'Failed to load categories'));
        }
      } catch (e) {
        emit(CategoryListError(e.toString()));
      }
    });

    // ---------------- PRODUCT LIST ----------------
    on<FetchProductListEventHandler>((event, emit) async {
      emit(ProductListLoading());
      try {
        final body = {
          'category_id': 5,
          'sort': 'latest',
          'min_price': null,
        };
        final params = _filterNulls(body);

        final res = await http.get(
          Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
        );

        final data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          emit(ProductListLoaded(data['products']));
        } else {
          emit(ProductListError(data['message'] ?? 'Failed to load products'));
        }
      } catch (e) {
        emit(ProductListError(e.toString()));
      }
    });

    // ---------------- CART PAGE ----------------
    on<FetchCartPageEventHandler>((event, emit) async {
      emit(CartPageLoading());
      try {
        final body = {
          'user_id': 123,
          'include_promotions': true,
        };
        final params = _filterNulls(body);

        final res = await http.get(
          Uri.parse(ApiConstants.baseUrl).replace(queryParameters: params),
        );

        final data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          emit(CartPageLoaded(data));
        } else {
          emit(CartPageError(data['message'] ?? 'Failed to load cart'));
        }
      } catch (e) {
        emit(CartPageError(e.toString()));
      }
    });

    // ---------------- ADD TO CART ----------------
    on<AddToCartEventHandler>((event, emit) async {
      emit(AddToCartLoading());
      try {
        final body = {
          'product_id': event.productId,
          'quantity': event.quantity,
          // 'note': 'Gift wrap',       // example optional
          // 'special_request': null,   // removed if null/empty
        };
        final filteredBody = _filterNulls(body);

        final res = await http.post(
          Uri.parse(ApiConstants.baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(filteredBody),
        );

        final data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          emit(AddToCartSuccess(data));
        } else {
          emit(AddToCartError(data['message'] ?? 'Failed to add to cart'));
        }
      } catch (e) {
        emit(AddToCartError(e.toString()));
      }
    });

    // ---------------- PRODUCT DETAILS ----------------
    on<FetchProductDetailsEventHandler>((event, emit) async {
      emit(ProductDetailsLoading());
      try {
        // body (example optional params)
        final body = {
          'product_id': event.productId,
          // 'include_reviews': true,
          // 'lang': '',
        };
        final params = _filterNulls(body);

        final res = await http.get(
          Uri.parse(ApiConstants.baseUrl)
              .replace(queryParameters: params),
        );

        final data = jsonDecode(res.body);
        if (res.statusCode == 200) {
          emit(ProductDetailsLoaded(data));
        } else {
          emit(ProductDetailsError(data['message'] ?? 'Failed to load details'));
        }
      } catch (e) {
        emit(ProductDetailsError(e.toString()));
      }
    });

  }

  /// Helper to remove null or empty-string values
  Map<String, dynamic> _filterNulls(Map<String, dynamic> body) {
    final filtered = <String, dynamic>{};
    body.forEach((k, v) {
      if (v != null && (v is! String || v.trim().isNotEmpty)) {
        filtered[k] = v;
      }
    });
    return filtered;
  }
}
