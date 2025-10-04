import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phone_form_field/phone_form_field.dart';

import 'package:basecam/ui/theme.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController fullNameController;
  late final TextEditingController dateBirthController;
  late final TextEditingController emailController;
  late final PhoneController phoneController;
  late PhoneNumber originalPhoneNumber;

  DateTime? cupertinoDate;

  String formatDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  @override
  void initState() {
    super.initState();
    // start with empty controllers; we'll load data from Firestore
    fullNameController = TextEditingController(text: '');
    dateBirthController = TextEditingController(text: '');
    emailController = TextEditingController(text: '');

    const defaultPhone = '+380687714099';
    originalPhoneNumber = defaultPhone.isNotEmpty
        ? PhoneNumber.parse(defaultPhone)
        : PhoneNumber(isoCode: IsoCode.UA, nsn: '');
    phoneController = PhoneController(initialValue: originalPhoneNumber);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUserData());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dateBirthController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // removed unused helpers

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final snapshot = await docRef.get();

    String? displayName;
    String? email;
    String? hpBday;
    String? phone;

    if (snapshot.exists) {
      final data = snapshot.data();
      displayName = data?['displayName'] as String?;
      email = data?['email'] as String?;
      hpBday = data?['hpBday'] as String?;
      // phone might be in profile.phone or top-level phone
      phone = (data?['profile'] is Map)
          ? (data?['profile']['phone'] as String?)
          : data?['phone'] as String?;
    }

    // Fallbacks: use auth email and defaults
    displayName ??= user.displayName ?? '';
    email ??= user.email ?? '';
    hpBday ??= '';
    phone ??= '+380687714099';

    // Populate controllers
    fullNameController.text = displayName;
    emailController.text = email;
    dateBirthController.text = hpBday;

    // phone is non-null here (we ensured a fallback); parse defensively
    try {
      phoneController.value = PhoneNumber.parse(phone);
    } catch (_) {
      phoneController.value = PhoneNumber(
        isoCode: IsoCode.UA,
        nsn: phone.replaceAll(RegExp(r'[^0-9]'), ''),
      );
    }

    // If document missing or fields empty, write defaults back to Firestore
    final toUpdate = <String, dynamic>{};
    if (!snapshot.exists) {
      toUpdate['displayName'] = displayName;
      toUpdate['email'] = email;
      toUpdate['hpBday'] = hpBday;
      toUpdate['phone'] = phone;
    } else {
      final data = snapshot.data()!;
      if ((data['displayName'] as String?)?.isNotEmpty != true)
        toUpdate['displayName'] = displayName;
      if ((data['email'] as String?)?.isNotEmpty != true)
        toUpdate['email'] = email;
      if ((data['hpBday'] as String?)?.isNotEmpty != true)
        toUpdate['hpBday'] = hpBday;
      if (((data['phone'] as String?)?.isNotEmpty ?? false) != true &&
          ((data['profile'] as Map?)?['phone'] as String?)?.isNotEmpty != true)
        toUpdate['phone'] = phone;
    }

    if (toUpdate.isNotEmpty) {
      await docRef.set(toUpdate, SetOptions(merge: true));
    }
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final String phoneDigits = phoneController.value.nsn;
    final String countryCode = phoneController.value.countryCode;
    final phoneFull = countryCode.isNotEmpty && phoneDigits.isNotEmpty
        ? '+$countryCode$phoneDigits'
        : phoneDigits;

    final payload = {
      'displayName': fullNameController.text.trim(),
      'email': emailController.text.trim(),
      'hpBday': dateBirthController.text.trim(),
      'phone': phoneFull,
      'profile': {'phone': phoneFull},
    };

    await docRef.set(payload, SetOptions(merge: true));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xFFF2F2F2),
                      child: Icon(Icons.person, size: 60, color: Colors.black),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeColors.greyColor,
                          width: 1,
                        ),
                        color: ThemeColors.background,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: SvgPicture.asset(
                          'assets/icons/events.svg',
                          width: 24,
                          height: 24,
                        ),
                        onPressed: () {
                          // Handle edit picture
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(hintText: "Full Name"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dateBirthController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                    _DateInputFormatter(),
                  ],
                  decoration: const InputDecoration(hintText: "DD/MM/YYYY"),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: PhoneFormField(
                        controller: phoneController,
                        isCountrySelectionEnabled: true,
                        isCountryButtonPersistent: true,
                        countrySelectorNavigator:
                            const CountrySelectorNavigator.bottomSheet(),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: ThemeColors.silverColor,
                              width: 2,
                            ),
                          ),
                        ),
                        countryButtonStyle: const CountryButtonStyle(
                          showDialCode: true,
                          showDropdownIcon: true,
                          showIsoCode: false,
                          flagSize: 0,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneFormatter],
                        decoration: const InputDecoration(
                          hintText: "(999) 111-0000",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: ThemeColors.silverColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (nsn) {
                          final currentIso = phoneController.value.isoCode;
                          phoneController.value = PhoneNumber(
                            isoCode: currentIso,
                            nsn: phoneFormatter.getUnmaskedText(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: ThemeColors.silverColor,
                          foregroundColor: ThemeColors.blackColor,
                        ),
                        onPressed: () async {
                          await _saveProfile();
                          context.pop();
                        },
                        child: const Text("Save changes"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;

    if (text.length >= 3 && text[2] != '/') {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }
    if (text.length >= 6 && text[5] != '/') {
      text = '${text.substring(0, 5)}/${text.substring(5)}';
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
