import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/authentications/submit_term_screen.dart';
import 'package:voicepocket/services/login_post.dart';
import 'package:voicepocket/widgets/login_button.dart';
import 'package:voicepocket/widgets/membership_button.dart';

import '../../constants/gaps.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final SharedPreferences _pref;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });
    SharedPreferences.getInstance().then((pref) => _pref = pref);
  }

  void _onScaffoldTab() {
    FocusScope.of(context).unfocus();
  }

  void _onLoginTab(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final loginModel = await loginPost(_email, _password);
      if (!mounted) return;
      if (loginModel.success) {
        Fluttertoast.showToast(
          msg: "${_pref.getString("name")!}님 환영합니다!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          backgroundColor: const Color(0xFFA594F9),
          fontSize: Sizes.size20,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      } else {
        _emailController.clear();
        _passwordController.clear();
        _onScaffoldTab();
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    controller: _emailController,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size16 + Sizes.size2,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "이메일을 입력 하시오";
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outline),
                      prefixIconColor: Colors.grey.shade400,
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
                      hintText: '이메일',
                      hintStyle: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Gaps.v10,
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    obscuringCharacter: '●',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: Sizes.size16 + Sizes.size2,
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "비밀번호를 입력 하시오";
                      }
                      return null;
                    },
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      prefixIconColor: Colors.grey.shade400,
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
                      hintStyle: TextStyle(
                        fontSize: Sizes.size16 + Sizes.size2,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w600,
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
    );
  }
}
