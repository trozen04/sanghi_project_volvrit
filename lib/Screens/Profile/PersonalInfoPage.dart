import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Screens/Profile/EditProfilePage.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/OtherReusableWidgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  bool isLoading = false;
  Map<String, dynamic> userData = {};

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Personal Info'),
      body: BlocProvider(
        create: (context) => ProfileBloc()..add(FetchProfileEventHandler()),
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is ProfileLoaded) {
              setState(() {
                userData = state.profileData;
                isLoading = false;
              });
            } else if (state is ProfileError) {
              setState(() {
                isLoading = false;
              });
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
                // List of info rows
                InfoRowWidget(
                  label: 'Name',
                  value: userData['personalName'] ?? '-',
                ),
                
                InfoRowWidget(
                  label: 'Phone Number',
                  value: '+91 ${userData['phone']}' ?? '-',
                ),
                
                InfoRowWidget(
                  label: 'Business Name',
                  value: userData['businessName'] ?? '-',
                ),
                
                InfoRowWidget(
                  label: 'GST Number',
                  value: userData['gstNumber'] ?? '-',
                ),
                
                InfoRowWidget(
                  label: 'Business Address',
                  value: userData['businessAddr'] ?? '-',
                ),
                
                InfoRowWidget(
                  label: 'Email',
                  value: userData['email'] ?? '-',
                ),
                SizedBox(height: height * 0.04),

                // Edit Profile button
                InkWell(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   AppRoutes.editProfilePage,
                    //   arguments: userData, // passing the profile data
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfilePage(profileData: userData),
                      ),
                    );


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
                          style: FFontStyles.quantity(16)
                              .copyWith(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
