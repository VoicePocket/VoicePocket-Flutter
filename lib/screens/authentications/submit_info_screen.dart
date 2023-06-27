import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:voicepocket/constants/gaps.dart';
import 'package:voicepocket/constants/sizes.dart';
import 'package:voicepocket/screens/authentications/submit_nickname_screen.dart';

class SubmitInfoScreen extends StatefulWidget {
  static const routeName = 'submit-info-screen';
  const SubmitInfoScreen({super.key});

  @override
  State<SubmitInfoScreen> createState() => _SubmitInfoScreenState();
}

class _SubmitInfoScreenState extends State<SubmitInfoScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _email = "";
  String _password = "";
  bool _obsecureText = true;

  void _onScaffoldTab() => FocusScope.of(context).unfocus();

  bool _isPasswordLengthValid() {
    return _password.length >= 8 && _password.length <= 20;
  }

  bool _isPasswordValid() {
    return _password.isNotEmpty && _isPasswordLengthValid();
  }

  bool _isEmailValid() {
    if (_email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
  }

  void _onSubmit() {
    if (!_isPasswordValid() || !_isEmailValid()) {
      return;
    }
    Navigator.of(context).pushNamed(SubmitNicknameScreen.routeName,
        arguments: {'email': _email, 'password': _password});
  }

  void _obsecureVisible() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 50,
            horizontal: 35,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '이메일과 비밀번호를\n입력해주세요.',
                style: TextStyle(
                  fontSize: Sizes.size32,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Gaps.v52,
              const Text(
                '이메일',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16 + Sizes.size2,
                ),
                controller: _emailController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  filled: true,
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
                          !_isEmailValid() ? Colors.red : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                ),
              ),
              Gaps.v16,
              const Text(
                '비밀번호',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              TextField(
                obscureText: _obsecureText,
                obscuringCharacter: '●',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: Sizes.size16 + Sizes.size2,
                ),
                controller: _passwordController,
                cursorColor: Theme.of(context).primaryColor,
                decoration: InputDecoration(
                  filled: true,
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
                          _password.isEmpty ? Colors.red : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size32,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obsecureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey.shade300,
                    ),
                    onPressed: () => _obsecureVisible(),
                  ),
                ),
              ),
              const Text(
                'Your password must have:',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  fontWeight: FontWeight.w900,
                  color: Color(0XFF929292),
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    _isPasswordLengthValid()
                        ? FontAwesomeIcons.circleCheck
                        : FontAwesomeIcons.circleXmark,
                    color: _isPasswordLengthValid() ? Colors.green : Colors.red,
                    size: Sizes.size20,
                  ),
                  Gaps.h5,
                  const Text(
                    '8 to 20 characters',
                    style: TextStyle(
                      fontSize: Sizes.size14,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF929292),
                    ),
                  ),
                ],
              ),
              Gaps.v96,
              GestureDetector(
                onTap: _onSubmit,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(Sizes.size32),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "다음으로",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
