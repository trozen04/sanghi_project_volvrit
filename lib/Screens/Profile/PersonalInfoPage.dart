import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/Screens/Profile/EditProfilePage.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

import '../../Utils/PrefUtils.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool isLoading = false;
  var userData = {};

  @override
  void initState() {
    super.initState();
    // Fetch profile initially
    final bloc = context.read<ProfileBloc>();
    bloc.add(FetchProfileEventHandler(userToken: Prefs.getUserToken()));
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Personal Info'),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            setState(() => isLoading = true);
          } else {
            setState(() => isLoading = false);
          }

          if (state is ProfileLoaded) {
            setState(() {
              userData = state.profileData;
            });
            developer.log('userData: $userData');
          } else if (state is ProfileError) {
            TopSnackbar.show(context, message: state.message);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.03,
          ),
          child: isLoading
              ? const PersonalInfoPageShimmer()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InfoRowWidget(label: 'Name', value: userData['personname'] ?? '-'),
              InfoRowWidget(label: 'Phone Number', value: '+91 ${userData['phoneno']}' ?? '-'),
              InfoRowWidget(label: 'Business Name', value: userData['bussinessname'] ?? '-'),
              InfoRowWidget(label: 'GST Number', value: userData['gstno'] ?? '-'),
              InfoRowWidget(label: 'Business Address', value: userData['bussinessaddress'] ?? '-'),
              InfoRowWidget(label: 'Email', value: userData['email'] ?? '-'),
              SizedBox(height: height * 0.04),

              // Edit Profile button
              InkWell(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(profileData: userData),
                    ),
                  );

                  if (result == true) {
                    // Refresh profile via Bloc, do NOT set isLoading manually
                    context.read<ProfileBloc>().add(
                      FetchProfileEventHandler(userToken: Prefs.getUserToken()),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.015,
                    horizontal: width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImageAssets.editProfile,
                        height: height * 0.025,
                        width: height * 0.025,
                      ),
                      SizedBox(width: width * 0.02),
                      Text(
                        'Edit Profile',
                        style: FFontStyles.quantity(16).copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}

