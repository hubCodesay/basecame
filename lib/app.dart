import 'package:flutter/material.dart';

import 'package:basecam/routes.dart';
import 'package:basecam/ui/theme.dart';


class BasecamApp extends StatefulWidget {
  const BasecamApp({super.key});

  @override
  State<BasecamApp> createState() => _BasecamAppState();
}

class _BasecamAppState extends State<BasecamApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router, 
    theme: lightTheme,
    );
  }
}