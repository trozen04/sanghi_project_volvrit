import 'package:flutter/material.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';
import 'package:gold_project/Widgets/custom_textfield.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _businessName = TextEditingController();
  final _gst = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();


  bool _nameError = false;
  bool _phoneError = false;
  bool _businessNameError = false;
  bool _addressError = false;
  bool _emailError = false;

  bool isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _businessName.dispose();
    _gst.dispose();
    _address.dispose();
    _email.dispose();
    super.dispose();
  }

  void _onSave() {
    setState(() {
      _nameError = _name.text.isEmpty;
      _phoneError = _phone.text.length < 10;
      _businessNameError = _businessName.text.isEmpty;
      _addressError = _address.text.isEmpty;
      _emailError = _email.text.isEmpty || !RegExp(r'^[\w\.\-]+@[\w\-]+\.\w+$').hasMatch(_email.text);
    });

    if (!_nameError && !_phoneError && !_businessNameError && !_addressError && !_emailError) {
      // Proceed with saving profile
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: 'Edit Profile'),
        body: isLoading
            ? EditProfilePageShimmer()
            : SingleChildScrollView(
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
              child: StaggeredReveal(
                initialDelay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 300),
                staggerFraction: 0.18,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Name', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _businessName,
                    hint: 'Enter your business name',
                    errorText: _businessNameError ? 'Business name cannot be empty' : null,
                    onChanged: (_) => setState(() => _businessNameError = false),
                  ),
                  SizedBox(height: height * 0.02),
                  Text('Person Name', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _name,
                    hint: 'Enter your name',
                    errorText: _nameError ? 'Name cannot be empty' : null,
                    onChanged: (_) => setState(() => _nameError = false),
                  ),
                  SizedBox(height: height * 0.02),
                  Text('Email', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    hint: 'Enter your email',
                    errorText: _emailError ? 'Enter a valid email address' : null,
                    onChanged: (_) => setState(() => _emailError = false),
                  ),
                  SizedBox(height: height * 0.02),
                  Text('Phone Number', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    hint: 'Enter your phone number',
                    errorText: _phoneError ? 'Phone number must be at least 10 digits' : null,
                    onChanged: (_) => setState(() => _phoneError = false),
                  ),
                  SizedBox(height: height * 0.02),
                  Text('GST Number (Optional)', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _gst,
                    hint: 'Enter your GST number',
                  ),
                  SizedBox(height: height * 0.02),
                  Text('Business Address', style: FFontStyles.emailLabel(16)),
                  SizedBox(height: height * 0.005),
                  CustomTextField(
                    controller: _address,
                    hint: 'Enter your business address',
                    errorText: _addressError ? 'Address cannot be empty' : null,
                    onChanged: (_) => setState(() => _addressError = false),
                  ),
                  SizedBox(height: height * 0.05),

                  ReusableButton(
                    text: 'Submit',
                    onPressed: _onSave,
                    width: width,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}