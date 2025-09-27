import 'package:flutter/material.dart';
import 'package:gold_project/Bloc/Profile/profile_bloc.dart';
import 'package:gold_project/ShimmersAndAnimations/Animations.dart';
import 'package:gold_project/ShimmersAndAnimations/Shimmers.dart';
import 'package:gold_project/Utils/AppColors.dart';
import 'package:gold_project/Utils/FFontStyles.dart';
import 'package:gold_project/Widgets/AppBar/CustomAppBar.dart';
import 'package:gold_project/Widgets/ReusableButton.dart';
import 'package:gold_project/Widgets/TopSnackbar.dart';
import 'package:gold_project/Widgets/custom_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const EditProfilePage({super.key, required this.profileData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _name;
  late TextEditingController _phone;
  late TextEditingController _businessName;
  late TextEditingController _gst;
  late TextEditingController _address;
  late TextEditingController _email;

  final _formKey = GlobalKey<FormState>();

  bool _nameError = false;
  bool _phoneError = false;
  bool _businessNameError = false;
  bool _addressError = false;
  bool _emailError = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final profileData = widget.profileData;

    _name = TextEditingController(text: profileData['personalName'] ?? '');
    _phone = TextEditingController(text: profileData['phone'] ?? '');
    _businessName =
        TextEditingController(text: profileData['businessName'] ?? '');
    _gst = TextEditingController(text: profileData['gstNumber'] ?? '');
    _address = TextEditingController(text: profileData['businessAddr'] ?? '');
    _email = TextEditingController(text: profileData['email'] ?? '');
  }

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

  void _onSave(BuildContext context) {
    setState(() {
      _nameError = _name.text.isEmpty;
      _phoneError = _phone.text.length < 10;
      _businessNameError = _businessName.text.isEmpty;
      _addressError = _address.text.isEmpty;
      _emailError =
          _email.text.isEmpty || !RegExp(r'^[\w\.\-]+@[\w\-]+\.\w+$').hasMatch(_email.text);
    });

    // Build error message
    String message = '';
    if (_businessNameError) message += 'Business name is required.\n';
    if (_nameError) message += 'Person name is required.\n';
    if (_emailError) message += 'Valid email is required.\n';
    if (_phoneError) message += 'Phone must be at least 10 digits.\n';
    if (_addressError) message += 'Address is required.\n';

    if (message.isNotEmpty) {
      TopSnackbar.show(context, message: message.trim(), isError: true);
      return;
    }

    // Dispatch update event if no errors
    context.read<ProfileBloc>().add(UpdateProfileEventHandler(
      name: _name.text,
      phone: _phone.text,
      businessName: _businessName.text,
      gst: _gst.text.isNotEmpty ? _gst.text : null,
      address: _address.text,
      email: _email.text,
    ));
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
        body: BlocProvider(
          create: (_) => ProfileBloc(),
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoading) {
                setState(() => isLoading = true);
              } else {
                setState(() => isLoading = false);
              }

              if (state is ProfileUpdated) {
                TopSnackbar.show(
                  context,
                  message: 'Profile updated successfully',
                  isError: false,
                );
                Navigator.pop(context, true); // return updated flag if needed
              } else if (state is ProfileError) {
                TopSnackbar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            child: isLoading
                ? EditProfilePageShimmer()
                : SingleChildScrollView(
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.03),
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
                    children: [
                      Text('Business Name',
                          style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _businessName,
                        hint: 'Enter your business name',
                        errorText: _businessNameError
                            ? 'Business name cannot be empty'
                            : null,
                        onChanged: (_) =>
                            setState(() => _businessNameError = false),
                      ),
                      SizedBox(height: height * 0.02),
                      Text('Person Name', style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _name,
                        hint: 'Enter your name',
                        errorText:
                        _nameError ? 'Name cannot be empty' : null,
                        onChanged: (_) =>
                            setState(() => _nameError = false),
                      ),
                      Text('Email', style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        hint: 'Enter your email',
                        errorText: _emailError
                            ? 'Enter a valid email address'
                            : null,
                        onChanged: (_) => setState(() => _emailError = false),
                      ),
                      Text('Phone Number', style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        hint: 'Enter your phone number',
                        errorText: _phoneError
                            ? 'Phone number must be at least 10 digits'
                            : null,
                        onChanged: (_) => setState(() => _phoneError = false),
                      ),
                      Text('GST Number (Optional)',
                          style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _gst,
                        hint: 'Enter your GST number',
                      ),
                      Text('Business Address', style: FFontStyles.emailLabel(16)),
                      SizedBox(height: height * 0.005),
                      CustomTextField(
                        controller: _address,
                        hint: 'Enter your business address',
                        errorText: _addressError
                            ? 'Address cannot be empty'
                            : null,
                        onChanged: (_) => setState(() => _addressError = false),
                      ),
                      SizedBox(height: height * 0.05),
                      ReusableButton(
                        text: 'Submit',
                        onPressed: () => _onSave(context),
                        width: width,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

