import 'package:flutter/material.dart';

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

class VoicePocketUri {
  //static const String iosUrl = "http://localhost:8080/api";
  static const String iosUrl = "http://3.35.254.95/api"; //실제 AWS주소
  //static const String androidUrl = "http://10.0.2.2:8080/api";
  static const String androidUrl = "http://3.35.254.95/api"; //실제 AWS주소
}
