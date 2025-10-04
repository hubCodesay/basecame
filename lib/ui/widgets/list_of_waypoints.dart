import 'package:flutter/material.dart';

class WaypointApp extends StatelessWidget {
  const WaypointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200], // Фоновий колір, схожий на зображення
        body: const Center(
          child: WaypointForm(),
        ),
      ),
    );
  }
}

class WaypointForm extends StatefulWidget {
  const WaypointForm({super.key});

  @override
  State<WaypointForm> createState() => _WaypointFormState();
}

class _WaypointFormState extends State<WaypointForm> {
  // Стиль для полів вводу
  InputDecoration _inputDecoration({
    String? hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    double borderRadius = 10.0,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Поле для адреси
            TextFormField(
              decoration: _inputDecoration(
                hintText: 'Input Waypoint address',
                prefixIcon: const Icon(Icons.menu, color: Colors.grey),
                suffixIcon: const Icon(Icons.keyboard_arrow_up, color: Colors.grey),
                borderRadius: 15.0,
              ),
            ),

            const SizedBox(height: 15),

            // Поле для назви
            TextFormField(
              decoration: _inputDecoration(
                hintText: 'Waypoint name',
                borderRadius: 10.0,
              ),
            ),

            const SizedBox(height: 15),

            // Поле для опису
            TextFormField(
              maxLines: 4,
              decoration: _inputDecoration(
                hintText: 'Description',
                borderRadius: 10.0,
              ),
            ),

            const SizedBox(height: 25),

            // Область для додавання фото
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  // style: BorderStyle.dashed,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Add Photo',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Кнопка видалення
            TextButton.icon(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Delete Waypoint',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              onPressed: () {
                // Дія при видаленні
                print('Waypoint deleted!');
              },
            ),
          ],
        ),
      ),
    );
  }
}