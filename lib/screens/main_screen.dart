import 'package:flutter/material.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/home_screen.dart';
import 'package:voicepocket/screens/submit_term_screen.dart';
import 'package:voicepocket/widgets/login_button.dart';
import 'package:voicepocket/widgets/membership_button.dart';

import '../constants/gaps.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onScaffoldTab() {
    FocusScope.of(context).unfocus();
  }

  void _onLoginTab(BuildContext context) {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    }
  }

  void _onSubmitTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubmitTermScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: _onScaffoldTab,
        child: Scaffold(
          backgroundColor: const Color(0xFFD8E4FF),
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Voice\nPocket',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "title_font",
                        fontSize: Sizes.size80,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        shadows: const <Shadow>[
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 3.0,
                            color: Colors.black38,
                          ),
                        ],
                      ),
                    ),
                    Gaps.v36,
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size16 + Sizes.size2,
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Please write your email";
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        hintText: '아이디',
                        hintStyle: const TextStyle(
                          fontSize: Sizes.size16 + Sizes.size2,
                          color: Color(0XFF929292),
                        ),
                      ),
                    ),
                    Gaps.v10,
                    TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: Sizes.size16 + Sizes.size2,
                      ),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Password";
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            Sizes.size32,
                          ),
                        ),
                        hintText: '비밀번호',
                        hintStyle: const TextStyle(
                          fontSize: Sizes.size16 + Sizes.size2,
                          color: Color(0XFF929292),
                        ),
                      ),
                    ),
                    Gaps.v32,
                    GestureDetector(
                      onTap: () => _onLoginTab(context),
                      child: const LoginButton(),
                    ),
                    GestureDetector(
                        onTap: () => _onSubmitTab(context),
                        child: const MembershipButton()),
                    Gaps.v11,
                    Text(
                      '아이디 / 비밀번호 찾기',
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v28,
                    Text(
                      'SNS 계정으로 시작하기',
                      style: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size1,
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
