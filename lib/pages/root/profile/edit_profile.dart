import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static final defaultDate = DateTime.now();
  DateTime? cupertinoDate;

  String formatDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  @override
  void initState() {
    super.initState();

    fullNameController = TextEditingController(text: "Albert Flores");
    dateBirthController = TextEditingController(text: "01/01/1988");
    emailController = TextEditingController(text: "albertflores@mail.com");

    const defaultPhone = "+380931234567";
    originalPhoneNumber = defaultPhone.isNotEmpty
        ? PhoneNumber.parse(defaultPhone)
        : PhoneNumber(isoCode: IsoCode.UA, nsn: '');
    phoneController = PhoneController(initialValue: originalPhoneNumber);

    WidgetsBinding.instance.addPostFrameCallback((_) => _validateData());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dateBirthController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // тимчасовий метод, щоб не ламався код
  void _validateData() {
    debugPrint("Validate data...");
  }

  void _onPhoneChanged(PhoneNumber? number) {
    debugPrint("Phone changed: $number");
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
                        icon: Image.asset(
                          'assets/icons/edit.png',
                          width: 16,
                          height: 16,
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
                          final currentIso =
                              phoneController.value.isoCode ?? IsoCode.UA;
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
                        onPressed: () {
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
