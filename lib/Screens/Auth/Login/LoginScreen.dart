import 'package:flutter/material.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      TopSnackbar.show(
          context,
          message: 'Login Successful.',
      );
      Prefs.setLoggedIn(true);
    }
    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
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
        body: Stack(
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
                                    return 'Please enter email';
                                  }
                                  if (!RegExp(Constants.emailPattern)
                                      .hasMatch(value)) {
                                    return 'Enter valid email';
                                  }
                                  return null;
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
                                    return 'Please enter password';
                                  }
                                  if (!RegExp(Constants.passwordPattern)
                                      .hasMatch(value)) {
                                    return 'Min 6 chars, letters & numbers';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              ReusableButton(
                                  text:  Constants.loginBtn,
                                  onPressed: _login,
                                  width: width,
                                isRounded: true,
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
    );
  }
}
