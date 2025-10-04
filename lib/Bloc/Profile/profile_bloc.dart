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
        final userId = Prefs.getUserId();

        // Build URL
        final url = '${ApiConstants.baseUrl}${ApiConstants.getProfile}$userId';
        developer.log('FetchProfileEventHandler url: $url');

        // Make GET request
        final res = await http.get(
            Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${event.userToken}',
            'Accept': 'application/json',
          },
        );

        final responseData = jsonDecode(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          final data = responseData['user'];
          Prefs.setUserName(data['personname']);
          Prefs.setUserEmail(data['email']);
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
        String? userId = Prefs.getUserId();
        final body = {
          'bussinessname': event.businessName,
          'personname': event.name,
          'gstno': event.gst?.isNotEmpty == true ? event.gst : null,
          'bussinessaddress': event.address,
        };

        final url = '${ApiConstants.baseUrl}${ApiConstants.updateProfile}';
        developer.log('url: $url, body: $body');

        final res = await http.patch(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${Prefs.getUserToken() ?? ''}',
            'Accept': 'application/json',
          },
          body: body,
        );

        final responseData = jsonDecode(res.body);
        developer.log('data: $responseData');
        developer.log('statusCode: ${res.statusCode}');

        if (res.statusCode == 200 || res.statusCode == 201) {
          developer.log('responseData[message]: ${responseData['message']}');

          emit(ProfileUpdated(responseData['message']));
        } else {
          emit(ProfileUpdateError(responseData['message'] ?? 'Failed to update profile'));
        }
      } catch (e) {
        emit(ProfileUpdateError(e.toString()));
      }
    });
  }
}
