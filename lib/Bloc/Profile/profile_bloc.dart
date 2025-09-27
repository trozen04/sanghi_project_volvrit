import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileEventHandler>((event, emit) async {
      emit(ProfileLoading());
      try {
        // Get userId directly
        final userId = await Prefs.getUserId();

        // Build URL
        final url = '${ApiConstants.baseUrl}${ApiConstants.getProfile}/$userId';
        developer.log('url: $url');

        // Make GET request
        final res = await http.get(Uri.parse(url));
        developer.log('body: ${res.body}');

        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200) {
          final data = responseData['data'];
          developer.log('responseData: $data');
          emit(ProfileLoaded(data));
        } else {
          emit(ProfileError(responseData['message'] ?? 'Failed to load profile'));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileEventHandler>((event, emit) async {
      emit(ProfileUpdating());
      try {
        String? userId = await Prefs.getUserId();
        final body = {
          'personalName': event.name,
          'phone': event.phone,
          'businessName': event.businessName,
          'gstNumber': event.gst?.isNotEmpty == true ? event.gst : null, // null if empty
          'businessAddr': event.address,
          //'email': event.email,
        };
        //..removeWhere((key, value) => value == null || value.toString().trim().isEmpty);

        final url = '${ApiConstants.baseUrl}${ApiConstants.updateProfile}/$userId';
        developer.log('url: $url, body: $body');

        final res = await http.put(
          Uri.parse(url),
          body: body,
        );

        final responseData = jsonDecode(res.body);
        developer.log('data: $responseData');

        if (res.statusCode == 200) {
          emit(ProfileUpdated(responseData));
        } else {
          emit(ProfileUpdateError(responseData['message'] ?? 'Failed to update profile'));
        }
      } catch (e) {
        emit(ProfileUpdateError(e.toString()));
      }
    });
  }
}
