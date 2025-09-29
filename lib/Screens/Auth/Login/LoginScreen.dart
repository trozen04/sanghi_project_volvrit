import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/AuthBloc/auth_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/Constants.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Utils/PrefUtils.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';
import 'package:gold_project/Widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailCtrl.text,
          password: _passCtrl.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is LoginLoading) {
              setState(() {
                isLoading = true;
              });
            } else if(state is LoginSuccess) {
              String message = state.response['message'];
              String userToken = state.response['token'];
              var user = state.response['user'];
              String userId = user['id'];

              TopSnackbar.show(context, message: message);
              setState(() {
                isLoading = false;
              });
              // Save preferences asynchronously
              Prefs.setLoggedIn(true);
              Prefs.setUserId(userId);
              Prefs.setUserId(userToken);
              Navigator.pushReplacementNamed(context, AppRoutes.dashboard);

            } else if(state is LoginError) {
              TopSnackbar.show(context, message: state.message, isError: true);
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Stack(
            children: [
              SizedBox(
                  height: height * 0.5,
                child: Image.asset(ImageAssets.LoginBG),
              ),
              ParallaxFadeIn(
                  offset: const Offset(-0.05, 0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    Image.asset(ImageAssets.appLogo, width: width * 0.24, height: height * 0.1),
                    SizedBox(height: height * 0.005),
                    Text(Constants.loginTitle,
                        style: FFontStyles.heading(28)),

                    SizedBox(height: height * 0.01),
                    Text(Constants.loginSubtitle,
                        style: FFontStyles.subtitle(16)),
                    SizedBox(height: height * 0.035),
                    Expanded(
                      child: Container(
                        width: width,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Constants.emailLabel,
                                    textAlign: TextAlign.left, style: FFontStyles.emailLabel(16)),

                                CustomTextField(
                                  controller: _emailCtrl,
                                  hint: Constants.emailHint,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!RegExp(Constants.emailPattern)
                                        .hasMatch(value)) {
                                      return 'Enter valid email';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) {
                                    // Re-run validation only for this field so its error disappears
                                    _formKey.currentState!.validate();
                                  },
                                ),

                                SizedBox(height: height * 0.01,),

                                Text(Constants.passwordLabel,
                                    textAlign: TextAlign.left, style: FFontStyles.emailLabel(16)),

                                CustomTextField(
                                  controller: _passCtrl,
                                  hint: Constants.passwordHint,
                                  obscure: true,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (!RegExp(Constants.passwordPattern)
                                        .hasMatch(value)) {
                                      return 'Min 6 chars, letters & numbers';
                                    }
                                    return null;
                                  },
                                  onChanged: (_) {
                                    // Re-run validation only for this field so its error disappears
                                    _formKey.currentState!.validate();
                                  },
                                ),
                                SizedBox(height: height * 0.02),
                                ReusableButton(
                                    text:  Constants.loginBtn,
                                    onPressed: _login,
                                    width: width,
                                  isRounded: true,
                                  isLoading: isLoading,
                                ),
                                SizedBox(height: height * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(Constants.noAccount,
                                        style: FFontStyles.noAccountText(14)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, AppRoutes.register);
                                      },
                                      child: Text(Constants.signup,
                                          style: FFontStyles.noAccountText(14).copyWith(color: AppColors.primary)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ),
),
      ),
    );
  }
}
