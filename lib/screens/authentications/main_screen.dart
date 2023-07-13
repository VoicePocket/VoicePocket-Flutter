import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/home_screen.dart';
import 'package:voicepocket/screens/authentications/submit_term_screen.dart';
import 'package:voicepocket/services/get_user_info.dart';
import 'package:voicepocket/services/login_post.dart';
import 'package:voicepocket/widgets/login_button.dart';
import 'package:voicepocket/widgets/membership_button.dart';

import '../../constants/gaps.dart';

class MainScreen extends StatefulWidget {
  static const routeName = 'main';
  static const routeURL = '/main';
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
    SharedPreferences.getInstance().then((pref) async {
      _pref = pref;
      if (pref.containsKey("email") &&
          pref.containsKey("password") &&
          pref.containsKey("fcmKey")) {
        final loginModel = await loginPost(
            pref.getString("email")!, pref.getString("password")!);
        if (!mounted) return;
        if (loginModel.success) {
          await getUserInfo(_pref.getString("email")!);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("환영합니다!"),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFA594F9),
            ),
          );
          // Fluttertoast.showToast(
          //   msg: "${pref.getString("name")!}님 환영합니다!",
          //   toastLength: Toast.LENGTH_LONG,
          //   gravity: ToastGravity.CENTER,
          //   timeInSecForIosWeb: 1,
          //   textColor: Colors.white,
          //   backgroundColor: const Color(0xFFA594F9),
          //   fontSize: Sizes.size20,
          // );
          if (!mounted) return;
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginModel.message),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red.shade500,
            ),
          );
        }
      }
    });
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
        await getUserInfo(_email);
        await _pref.setString("email", _email);
        await _pref.setString("password", _password);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("환영합니다!"),
            duration: Duration(seconds: 1),
            backgroundColor: Color(0xFFA594F9),
          ),
        );
        // Fluttertoast.showToast(
        //   msg: "${_pref.getString("name")!}님 환영합니다!",
        //   toastLength: Toast.LENGTH_LONG,
        //   gravity: ToastGravity.CENTER,
        //   timeInSecForIosWeb: 1,
        //   textColor: Colors.white,
        //   backgroundColor: const Color(0xFFA594F9),
        //   fontSize: Sizes.size20,
        // );
        if (!mounted) return;
        context.pushReplacementNamed(HomeScreen.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginModel.message),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red.shade500,
          ),
        );
        _emailController.clear();
        _passwordController.clear();
        _onScaffoldTab();
      }
    }
  }

  void _onSubmitTab(BuildContext context) {
    context.pushNamed(SubmitTermScreen.routeName);
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
        backgroundColor: Colors.white,
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
                      fontSize: Sizes.size64,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).primaryColor,
                      shadows: <Shadow>[
                        Shadow(
                          offset: const Offset(0, 10),
                          blurRadius: 8.0,
                          color: Colors.black.withOpacity(0.15),
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
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
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
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(
                          Sizes.size32,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
