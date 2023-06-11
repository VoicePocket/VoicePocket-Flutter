
import 'package:flutter/material.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

class VoicePocketUri {
  static const String iosUrl = "http://localhost:8080/api";
  static const String androidUrl = "http://localhost:8080/api";
}
