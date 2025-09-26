import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/AuthBloc/auth_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/Routes/app_routes.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/Constants.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Utils/ImageAssets.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';
import 'package:gold_project/Widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _personName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _gst = TextEditingController();
  final _address = TextEditingController();

  // Error flags
  bool _businessNameError = false;
  bool _personNameError = false;
  bool _emailError = false;
  bool _phoneError = false;
  bool _addressError = false;

  @override
  void dispose() {
    _businessName.dispose();
    _personName.dispose();
    _email.dispose();
    _phone.dispose();
    _gst.dispose();
    _address.dispose();
    super.dispose();
  }

  void _onSignup() {
    setState(() {
      _businessNameError = _businessName.text.isEmpty;
      _personNameError = _personName.text.isEmpty;
      _emailError = _email.text.isEmpty ||
          !RegExp(r'^[\w\.\-]+@[\w\-]+\.\w+$').hasMatch(_email.text);
      _phoneError = _phone.text.length < 10;
      _addressError = _address.text.isEmpty;
    });

    if (!_businessNameError &&
        !_personNameError &&
        !_emailError &&
        !_phoneError &&
        !_addressError) {

      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _personName.text,
          email: _email.text,
          password: _phone.text, // or whatever your password field is
          contact: _phone.text,
          gst: _gst.text.isNotEmpty ? _gst.text : null,
          businessName: _businessName.text.isNotEmpty ? _businessName.text : null,
          address: _address.text.isNotEmpty ? _address.text : null,
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.primary,
        body: Stack(
          children: [
            Container(
              height: height * 0.5,
              child: Image.asset(ImageAssets.LoginBG),
            ),
            ParallaxFadeIn(
              offset: const Offset(-0.05, 0),
              child: Column(
                children: [
                  SizedBox(height: height * 0.05),
                  Image.asset(ImageAssets.appLogo, width: width * 0.24, height: height * 0.1),
                  SizedBox(height: height * 0.003),
                  Text(Constants.signUpTitle, style: FFontStyles.heading(28)),
                  SizedBox(height: height * 0.005),
                  Text(Constants.loginSubtitle, style: FFontStyles.subtitle(16)),
                  SizedBox(height: height * 0.03),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Container(
                        width: width,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.03),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Business Name
                              Text('Business Name', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _businessName,
                                hint: 'Enter your business name',
                                errorText: _businessNameError ? 'Business name cannot be empty' : null,
                                onChanged: (_) => setState(() => _businessNameError = false),
                                textCapitalization: TextCapitalization.words,
                              ),
                              SizedBox(height: height * 0.01),

                              // Person Name
                              Text('Person Name', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _personName,
                                hint: 'Enter your name',
                                errorText: _personNameError ? 'Please enter your name' : null,
                                onChanged: (_) => setState(() => _personNameError = false),
                                textCapitalization: TextCapitalization.words,
                              ),
                              SizedBox(height: height * 0.01),

                              // Email
                              Text('Email', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                hint: Constants.emailHint,
                                errorText: _emailError ? 'Enter a valid email address' : null,
                                onChanged: (_) => setState(() => _emailError = false),
                              ),
                              SizedBox(height: height * 0.01),

                              // Phone Number
                              Text('Phone Number', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                                hint: 'Enter your phone number',
                                errorText: _phoneError ? 'Phone number must be at least 10 digits' : null,
                                onChanged: (_) => setState(() => _phoneError = false),
                              ),
                              SizedBox(height: height * 0.01),

                              // GST Number (Optional)
                              Text('GST number(optional)', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _gst,
                                hint: 'Enter your GST number',
                              ),
                              SizedBox(height: height * 0.01),

                              // Business Address
                              Text('Business Address', style: FFontStyles.emailLabel(16)),
                              CustomTextField(
                                controller: _address,
                                maxLines: 1,
                                hint: 'Enter your business address',
                                errorText: _addressError ? 'Address cannot be empty' : null,
                                onChanged: (_) => setState(() => _addressError = false),
                              ),

                              // Signup Button
                              SizedBox(height: height * 0.02),
                              ReusableButton(
                                text:  Constants.signup,
                                onPressed: _onSignup,
                                width: width,
                                isRounded: true,
                              ),
                              SizedBox(height: height * 0.02),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(Constants.noAccount, style: FFontStyles.noAccountText(14)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, AppRoutes.login);
                                    },
                                    child: Text(Constants.loginBtn,
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
