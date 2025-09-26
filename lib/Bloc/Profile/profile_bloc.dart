import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:gold_project/Utils/ApiConstants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileEventHandler>(_onFetchProfile);
    on<UpdateProfileEventHandler>(_onUpdateProfile);
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

  Future<void> _onFetchProfile(
      FetchProfileEventHandler event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      // body (example optional params)
      final body = {
        'token': 'user-token',
      };
      final params = _filterNulls(body);

      final res = await http.get(
        Uri.parse(ApiConstants.baseUrl)
            .replace(queryParameters: params),
      );

      if (res.statusCode == 200) {
        emit(ProfileLoaded(jsonDecode(res.body)));
      } else {
        emit(ProfileError('Failed to load profile'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfileEventHandler event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      // body (send only non-null fields)
      final body = {
        'name': event.name,
        'phone': event.phone,
        'business_name': event.businessName,
        'gst': event.gst,
        'address': event.address,
        'email': event.email,
        // 'token': 'user-token', // example
      };
      final params = _filterNulls(body);

      final res = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        body: params,
      );

      if (res.statusCode == 200) {
        emit(ProfileUpdated(jsonDecode(res.body)));
      } else {
        emit(ProfileUpdateError('Failed to update profile'));
      }
    } catch (e) {
      emit(ProfileUpdateError(e.toString()));
    }
  }
}
