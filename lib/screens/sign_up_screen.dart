import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../utils/countries.dart';
import '../widgets/app_text_field.dart';
import '../widgets/consent_row.dart';
import '../widgets/country_code.dart';
import '../widgets/profile_avatar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobile = TextEditingController();
  final altMobile = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  bool agreed = false;
  File? photo;
  Country mobileCountry = uae;
  Country altCountry = uae;

  final mobileRegex = RegExp(r'^\d{9}$');
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');

  final phoneFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(9),
  ];

  bool get isMobileValid => mobileRegex.hasMatch(mobile.text);
  bool get isAltMobileValid => mobileRegex.hasMatch(altMobile.text);
  bool get isEmailValid => emailRegex.hasMatch(email.text.trim());

  bool get canSubmit {
    return firstName.text.trim().isNotEmpty &&
        lastName.text.trim().isNotEmpty &&
        isMobileValid &&
        (altMobile.text.isEmpty || isAltMobileValid) &&
        isEmailValid &&
        password.text.length >= 8 &&
        confirmPassword.text == password.text &&
        agreed;
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    mobile.dispose();
    altMobile.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void update() => setState(() {});

  Future<void> pickPhoto() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    setState(() => photo = File(picked.path));
  }

  void submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Account created')));
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    // the design has 44px status and navigation bars, android ones are
    // usually smaller, so use at least 44 to keep the same spacing
    final statusBar = max(padding.top, 44.0);
    final navigationBar = max(padding.bottom, 44.0);

    // button is 52 high and 20 above the navigation bar
    final buttonArea = navigationBar + 20 + 52;

    // the keyboard covers the button, so only the part that overlaps the
    // form is taken off the scroll area
    final keyboardOverForm = max(0.0, keyboard - buttonArea);

    // very short screens: hide the avatar while typing so the form has room
    final screenHeight = MediaQuery.of(context).size.height;
    final headerHeight = statusBar + 6 + 25 + 22 + 100 + 15;
    final formHeight = screenHeight - max(keyboard, buttonArea) - headerHeight;
    final hideAvatar = formHeight < 120;

    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: EdgeInsets.only(top: statusBar + 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header(),
              if (!hideAvatar) ...[const SizedBox(height: 22), avatar()],
              const SizedBox(height: 15),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: keyboardOverForm),
                  child: SingleChildScrollView(
                    // 30px minimum space above the button
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: form(),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, navigationBar + 20),
                child: SizedBox(height: 52, child: submitButton()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return SizedBox(
      height: 25,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.maybePop(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SvgPicture.asset('assets/icons/back_arrow.svg'),
              ),
            ),
          ),
          const Text('Create an account', style: AppText.title),
        ],
      ),
    );
  }

  Widget avatar() {
    return Center(
      child: ProfileAvatar(photo: photo, onTap: pickPhoto),
    );
  }

  Widget form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 15,
      children: [
        Row(
          spacing: 21,
          children: [
            Expanded(
              child: AppTextField(
                controller: firstName,
                label: '* First name',
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => update(),
              ),
            ),
            Expanded(
              child: AppTextField(
                controller: lastName,
                label: '* Last name',
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (_) => update(),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            infoText(
              'This mobile number will be used for you to Sign In\n'
              'and will allow us to call you upon your request',
            ),
            AppTextField(
              controller: mobile,
              label: '* Mobile number',
              hint: '* Mobile number (ex: 5********)',
              prefix: CountryCode(
                country: mobileCountry,
                onChanged: (value) => setState(() => mobileCountry = value),
              ),
              showCheckSpace: true,
              showCheck: isMobileValid,
              keyboardType: TextInputType.phone,
              inputFormatters: phoneFormatters,
              onChanged: (_) => update(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            infoText(
              'Do you have an alternative mobile number for messaging?\n'
              '(WhatsApp or Telegram)',
            ),
            AppTextField(
              controller: altMobile,
              label: 'Mobile number (optional)',
              prefix: CountryCode(
                country: altCountry,
                onChanged: (value) => setState(() => altCountry = value),
              ),
              showCheckSpace: true,
              showCheck: isAltMobileValid,
              keyboardType: TextInputType.phone,
              inputFormatters: phoneFormatters,
              onChanged: (_) => update(),
            ),
          ],
        ),
        AppTextField(
          controller: email,
          label: '* Email address',
          showCheckSpace: true,
          showCheck: isEmailValid,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          onChanged: (_) => update(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            AppTextField(
              controller: password,
              label: '* Password',
              isPassword: true,
              keyboardType: TextInputType.visiblePassword,
              onChanged: (_) => update(),
            ),
            AppTextField(
              controller: confirmPassword,
              label: '* Confirm password',
              isPassword: true,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              onChanged: (_) => update(),
            ),
          ],
        ),
        ConsentRow(
          checked: agreed,
          onTap: () => setState(() => agreed = !agreed),
        ),
      ],
    );
  }

  Widget infoText(String text) {
    return SizedBox(
      height: 32,
      child: Text(text, textAlign: TextAlign.center, style: AppText.info),
    );
  }

  Widget submitButton() {
    return Material(
      color: canSubmit ? AppColors.brand : AppColors.lightGrey,
      borderRadius: BorderRadius.circular(65),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: canSubmit ? submit : null,
        child: const Center(
          child: Text('Create my account', style: AppText.button),
        ),
      ),
    );
  }
}
