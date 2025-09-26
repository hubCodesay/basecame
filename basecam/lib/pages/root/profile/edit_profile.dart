import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:basecam/stubs.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  late final TextEditingController phoneNsnController;
  late PhoneNumber originalPhoneNumber;
  bool isPhoneEditing = true;
  String? avatarUrl;
  String displayPhone = '';

  DateTime? cupertinoDate;

  String formatDate(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  @override
  void initState() {
    super.initState();

    // start with empty controllers, then load real values from Firestore
    fullNameController = TextEditingController();
    dateBirthController = TextEditingController();
    emailController = TextEditingController();

    const defaultPhone = "+380931234567";
    originalPhoneNumber = defaultPhone.isNotEmpty
        ? PhoneNumber.parse(defaultPhone)
        : PhoneNumber(isoCode: IsoCode.UA, nsn: '');
    phoneController = PhoneController(initialValue: originalPhoneNumber);
    phoneNsnController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) => _validateData());

    // load user data from Firestore into controllers
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      // avatar url may be stored under profile.avatarUrl or top-level avatarUrl
      if (data['profile'] is Map) {
        avatarUrl = data['profile']['avatarUrl'] as String?;
      }
      avatarUrl = avatarUrl ?? (data['avatarUrl'] as String?);

      // displayName is usually stored at top-level but fall back to profile.displayName
      final displayName =
          (data['displayName'] as String?) ??
          ((data['profile'] is Map)
              ? (data['profile']['displayName'] as String?)
              : null) ??
          '';

      // hpBday might be stored top-level or under profile.hpBday
      String? hpBday;
      if (data['profile'] is Map) {
        hpBday = data['profile']['hpBday'] as String?;
      }
      hpBday = hpBday ?? (data['hpBday'] as String?);

      // email often comes from auth but we keep the Firestore value if present
      final email =
          (data['email'] as String?) ??
          FirebaseAuth.instance.currentUser?.email ??
          '';

      // phone may be top-level or under profile.phone
      String? phone;
      if (data['profile'] is Map) {
        phone = data['profile']['phone'] as String?;
      }
      phone = phone ?? (data['phone'] as String?);

      // Update controllers (no need to call setState when changing controller.text)
      fullNameController.text = displayName;
      dateBirthController.text = hpBday ?? '';
      emailController.text = email;

      if (phone != null && phone.isNotEmpty) {
        try {
          phoneController.value = PhoneNumber.parse(phone);
        } catch (_) {
          // ignore parse errors, keep default
        }
        // also populate the visible NSN field with a masked value
        var nsn = phoneController.value.nsn;

        // Heuristic: if the full string begins with a +<code> and the nsn
        // also starts with the same digits, strip that prefix so the
        // right-hand field shows only the local number.
        final full = phoneController.value.toString(); // e.g. +380931234567
        if (full.startsWith('+') && nsn.isNotEmpty) {
          final digits = full.substring(1); // e.g. 380931234567
          // try prefix lengths 1..3 (country codes are 1-3 digits)
          for (var len = 1; len <= 3 && len <= digits.length; len++) {
            final codeCandidate = digits.substring(0, len);
            if (nsn.startsWith(codeCandidate)) {
              nsn = nsn.substring(len);
              break;
            }
          }
        }

        phoneNsnController.text = _formatNsn(nsn);
      }

      // keep a raw display string (prefer the DB value if present)
      // Normalize to digits-only so we never show the PhoneNumber(...) debug
      // representation in the UI.
      if (phone != null && phone.isNotEmpty) {
        // If we successfully parsed into phoneController above, prefer that.
        try {
          displayPhone = _digitsFromPhoneNumber(phoneController.value);
        } catch (_) {
          displayPhone = _digitsFromRaw(phone);
        }
      } else {
        displayPhone = '';
      }

      // set editing mode: if phone exists -> show display mode, otherwise allow editing
      final hasPhone = phone != null && phone.isNotEmpty;
      setState(() {
        isPhoneEditing = !hasPhone;
      });
    } catch (e) {
      debugPrint('Failed to load user data: $e');
    }
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final displayName = fullNameController.text.trim();
    final hpBday = dateBirthController.text.trim();
    // save only digits for phone number (e.g. 380931234567)
    final phone = _digitsFromPhoneNumber(phoneController.value);

    try {
      // merge changes into the existing document. Write both top-level and profile.hpBday
      await userRef.set({
        'displayName': displayName,
        'hpBday': hpBday,
        'phone': phone,
        'profile': {'hpBday': hpBday, 'phone': phone},
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
      // update displayed phone
      setState(() {
        displayPhone = phone;
      });
    } catch (e) {
      debugPrint('Failed to save user data: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    }
  }

  Future<void> _changeAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final pick = await showModalBottomSheet<String?>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(ctx, 'gallery'),
              ),
              ListTile(
                leading: const Icon(Icons.link),
                title: const Text('Paste image URL'),
                onTap: () => Navigator.pop(ctx, 'url'),
              ),
              if (avatarUrl != null && avatarUrl!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete photo'),
                  onTap: () => Navigator.pop(ctx, 'delete'),
                ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(ctx, null),
              ),
            ],
          ),
        );
      },
    );

    if (pick == null) return;

    if (pick == 'url') {
      final urlController = TextEditingController();
      final res = await showDialog<String?>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Paste avatar image URL'),
          content: TextField(controller: urlController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, urlController.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (res == null || res.isEmpty) return;

      try {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        await userRef.set({
          'profile': {'avatarUrl': res},
        }, SetOptions(merge: true));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Avatar saved')));
        await _loadUserData();
        setState(() {});
      } catch (e) {
        debugPrint('Failed to save avatar: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
      }
    } else if (pick == 'gallery') {
      try {
        final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 85,
        );
        if (image == null) return;

        // upload to Firebase Storage
        final path =
            'avatars/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final ref = FirebaseStorage.instance.ref().child(path);

        // show progress indicator with percentage
        double progress = 0;
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => StatefulBuilder(
            builder: (c, setStateDialog) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                    Text('${(progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              );
            },
          ),
        );

        UploadTask? uploadTask;
        try {
          final metadata = SettableMetadata(contentType: 'image/jpeg');
          debugPrint('Picked image path: ${image.path}');
          final storageBucket =
              FirebaseStorage.instance.app.options.storageBucket;
          debugPrint('Firebase Storage bucket: $storageBucket');

          if (kIsWeb) {
            final bytes = await image.readAsBytes();
            debugPrint('Image byte length (web): ${bytes.length}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Uploading avatar...')),
            );
            uploadTask = ref.putData(bytes, metadata);
          } else {
            // mobile: prefer putFile but verify file exists and fall back to bytes if needed
            final file = File(image.path);
            if (file.existsSync()) {
              debugPrint(
                'Uploading file via putFile, size: ${file.lengthSync()}',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uploading avatar...')),
              );
              try {
                uploadTask = ref.putFile(file, metadata);
              } catch (e) {
                debugPrint('putFile threw: $e — will try putData fallback');
                final bytes = await image.readAsBytes();
                debugPrint('Image byte length (fallback): ${bytes.length}');
                uploadTask = ref.putData(bytes, metadata);
              }
            } else {
              // file not found on disk — fallback to bytes
              debugPrint(
                'File not found at ${image.path}, falling back to putData',
              );
              final bytes = await image.readAsBytes();
              debugPrint('Image byte length (fallback): ${bytes.length}');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Uploading avatar...')),
              );
              uploadTask = ref.putData(bytes, metadata);
            }
          }

          // listen for progress
          final sub = uploadTask.snapshotEvents.listen((snapshot) {
            final bytesTransferred = snapshot.bytesTransferred.toDouble();
            final total = snapshot.totalBytes.toDouble();
            if (total > 0) {
              progress = (bytesTransferred / total).clamp(0.0, 1.0);
            }
            try {
              // update dialog
              (context as Element).markNeedsBuild();
            } catch (_) {}
          });

          // wait for completion
          await uploadTask.whenComplete(() => null);
          await sub.cancel();

          final downloadUrl = await ref.getDownloadURL();
          try {
            Navigator.of(context).pop(); // dismiss progress
          } catch (_) {}

          final userRef = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid);
          await userRef.set({
            'profile': {'avatarUrl': downloadUrl},
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Avatar uploaded')));
          await _loadUserData();
          setState(() {});
        } catch (e, st) {
          try {
            Navigator.of(context).pop();
          } catch (_) {}
          debugPrint('Failed to upload avatar: $e\n$st');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
        }
      } catch (e) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
        debugPrint('Failed to upload avatar: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      }
    } else if (pick == 'delete') {
      await _deleteAvatar();
    }
  }

  Future<void> _deleteAvatar() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (avatarUrl == null || avatarUrl!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No avatar to delete')));
      return;
    }

    final confirm = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete avatar'),
        content: const Text('Are you sure you want to delete your avatar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      // Attempt to delete the file from Firebase Storage if possible
      try {
        final ref = FirebaseStorage.instance.refFromURL(avatarUrl!);
        await ref.delete();
      } catch (e) {
        // Could fail if URL is not from same storage bucket or already deleted — ignore but log
        debugPrint('Could not delete storage object: $e');
      }

      // Remove the field from Firestore (nested field)
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      try {
        await userRef.update({'profile.avatarUrl': FieldValue.delete()});
      } catch (e) {
        // If update fails (doc doesn't exist), fall back to merge set with null
        debugPrint('Update failed, falling back to set null: $e');
        await userRef.set({
          'profile': {'avatarUrl': null},
        }, SetOptions(merge: true));
      }

      avatarUrl = null;
      await _loadUserData();
      setState(() {});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Avatar deleted')));
    } catch (e) {
      debugPrint('Failed to delete avatar: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  String _formatNsn(String nsn) {
    // format plain digits into (###) ###-#### or partial
    final digits = nsn.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    if (digits.length <= 3) return '(${digits.substring(0, digits.length)}';
    if (digits.length <= 6) {
      final a = digits.substring(0, 3);
      final b = digits.substring(3);
      return '($a) $b';
    }
    final a = digits.substring(0, 3);
    final b = digits.substring(3, 6);
    final c = digits.substring(6, digits.length);
    return '($a) $b-${c}';
  }

  // Return only digit characters from an input string, or empty string if null
  String _digitsFromRaw(String? input) {
    if (input == null) return '';
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }

  // Build digits-only phone number from a PhoneNumber instance.
  // Prefer countryCode + nsn when available, otherwise fall back to extracting digits
  // from the raw PhoneNumber.toString() value.
  String _digitsFromPhoneNumber(PhoneNumber? pn) {
    if (pn == null) return '';
    try {
      final nsn = pn.nsn.toString();
      final cc = pn.countryCode.toString();
      if (nsn.isNotEmpty) {
        return '$cc$nsn';
      }
    } catch (_) {}
    return _digitsFromRaw(pn.toString());
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

  // phone change handler removed (unused)

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
                    GestureDetector(
                      onTap: _changeAvatar,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: const Color(0xFFF2F2F2),
                        child: ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: avatarUrl == null || avatarUrl!.isEmpty
                                ? SvgPicture.asset(
                                    'assets/icons/ava_user.svg',
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (context) =>
                                        const Center(
                                          child: Icon(
                                            Icons.person,
                                            size: 28,
                                            color: Colors.black54,
                                          ),
                                        ),
                                  )
                                : (avatarUrl!.toLowerCase().endsWith('.svg')
                                      ? SvgPicture.network(
                                          avatarUrl!,
                                          fit: BoxFit.cover,
                                          placeholderBuilder: (context) =>
                                              const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                        )
                                      : Image.network(
                                          avatarUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  SvgPicture.asset(
                                                    'assets/icons/ava_user.svg',
                                                    fit: BoxFit.cover,
                                                  ),
                                        )),
                          ),
                        ),
                      ),
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
                // Phone controls: either editing (selector + input) or display mode
                if (isPhoneEditing)
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                          controller: phoneNsnController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [phoneFormatter],
                          decoration: const InputDecoration(
                            hintText: "(999) 111-0000",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
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
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ThemeColors.silverColor,
                              width: 2,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            displayPhone.isNotEmpty
                                ? displayPhone
                                : _digitsFromPhoneNumber(phoneController.value),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            isPhoneEditing = true;
                          });
                        },
                        child: const Text('Змінити'),
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
                          await _saveChanges();
                          if (mounted) context.pop();
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
