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
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _id = "";
  String _password = "";

  void _onScaffoldTab() {
    FocusScope.of(context).unfocus();
  }

  bool _isLoginValid() {
    return _id.isNotEmpty && _password.isNotEmpty;
  }

  void _onLoginTab(BuildContext context) {
    if (!_isLoginValid()) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  void _onSubmitTab(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubmitTermScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _idController.addListener(() {
      setState(() {
        _id = _idController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Voice\nPocket',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "title_font",
                      fontSize: Sizes.size80,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                      shadows: const <Shadow>[
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 3.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  Gaps.v36,
                  TextField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size16 + Sizes.size2,
                    ),
                    controller: _idController,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
                          color:
                              _id.isEmpty ? Colors.red : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      labelText: '아이디',
                      labelStyle: const TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        color: Color(0XFF929292),
                      ),
                    ),
                  ),
                  Gaps.v10,
                  TextField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size16 + Sizes.size2,
                    ),
                    controller: _passwordController,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
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
                          color: _password.isEmpty
                              ? Colors.red
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        color: Color(0XFF929292),
                      ),
                    ),
                  ),
                  Gaps.v32,
                  GestureDetector(
                    onTap: () => _onLoginTab(context),
                    child: LoginButton(disabled: !_isLoginValid()),
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
    );
  }
}
